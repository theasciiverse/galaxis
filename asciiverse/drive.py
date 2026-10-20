"""drive.py SESSION: plays Galaxis in a 100x30 tmux pane for the catalog
preview (asciiverse/record.sh), as a reasoning player.

A probe counts the directions (of eight) in which it sees a lifeboat;
each direction counts only its first boat. The driver reads the board
from the pane (the 80x24 screen centred at 100x30: the board's corner at
row 3, column 10), remembers each probe's count, and looks for lifeboat
placements that agree with every count (random placements improved by
moving one boat at a time, many restarts). It probes the square that
the most of them share, so a probe on a lifeboat finds it. The cursor
is walked there with h j k l (the board wraps). Plays until all four
lifeboats are found, or SECONDS (default 70) have passed."""
import os, random, subprocess, sys, time

S = sys.argv[1]
secs = float(os.environ.get("SECONDS_LIMIT", "70"))
TMUX = ["tmux", "-L", os.environ.get("TMUX_SOCKET", "default")]
W, H, BOATS = 20, 9, 4
OY, OX = 3, 10              # the 80x24 screen's corner at 100x30
PY0, PX0 = 3, 7             # galaxis' PYBASE and PXBASE
DIRS = [(0, 1), (1, 1), (1, 0), (1, -1), (0, -1), (-1, -1), (-1, 0), (-1, 1)]
rng = random.Random(5)


def key(*k):
    subprocess.run(TMUX + ["send-keys", "-t", S, *k])


def screen():
    out = subprocess.run(TMUX + ["capture-pane", "-p", "-t", S],
                         capture_output=True, text=True).stdout
    return [r.ljust(100) for r in (out.split("\n") + [""] * 30)[:30]]


def board(rows):
    """{(y, x): char} of the board as shown."""
    b = {}
    for y in range(H):
        r = rows[OY + PY0 + y]
        for x in range(W):
            b[(y, x)] = r[OX + PX0 + (x + 1) * 3]
    return b


def count(p, boats):
    n = 0
    for dy, dx in DIRS:
        y, x = p
        while True:
            y, x = y + dy, x + dx
            if not (0 <= y < H and 0 <= x < W):
                break
            if (y, x) in boats:
                n += 1
                break
    return n


def placements(probes, found, free, tries=300):
    """Distinct lifeboat placements agreeing with every probe."""
    need = BOATS - len(found)
    free = list(free)
    if need <= 0 or len(free) < need:
        return []
    out = set()
    def badness(bs):
        allb = set(bs) | found
        return sum(abs(count(p, allb) - c) for p, c in probes.items())
    for _ in range(tries):
        bs = rng.sample(free, need)
        bad = badness(bs)
        for _ in range(60):
            if bad == 0:
                break
            i = rng.randrange(need)
            c = rng.choice(free)
            if c in bs:
                continue
            nb = bs[:i] + [c] + bs[i + 1:]
            nbad = badness(nb)
            if nbad <= bad:
                bs, bad = nb, nbad
        if bad == 0:
            out.add(frozenset(bs))
    return list(out)


def goto(cur, target):
    cy, cx = cur
    ty, tx = target
    dx = (tx - cx) % W
    keys = ["l"] * dx if dx <= W // 2 else ["h"] * (W - dx)
    dy = (ty - cy) % H
    keys += ["j"] * dy if dy <= H // 2 else ["k"] * (H - dy)
    for k in keys:
        key(k)
        time.sleep(0.07)
    return target


time.sleep(1.5)
t0 = time.time()
cur = (H // 2, W // 2)
probes = {}
while time.time() - t0 < secs:
    rows = screen()
    if "play again" in "".join(rows):
        break
    b = board(rows)
    found = {p for p, c in b.items() if c == "L"}
    if len(found) >= BOATS:
        break
    free = {p for p, c in b.items() if c == "." and p not in probes}
    sols = placements(probes, found, free)
    if sols:
        tally = {}
        for s in sols:
            for p in s:
                tally[p] = tally.get(p, 0) + 1
        best = max(tally.values())
        target = rng.choice([p for p, n in tally.items() if n == best])
    else:
        target = rng.choice(sorted(free))
    cur = goto(cur, target)
    time.sleep(0.25)
    key("p")
    time.sleep(0.6)
    c = board(screen())[target]
    if c.isdigit():
        probes[target] = int(c)
    time.sleep(0.4)
time.sleep(2.5)
