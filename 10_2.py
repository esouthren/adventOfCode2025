#!/usr/bin/env python3
from z3 import Int, Optimize, Sum, sat


def parse_line(line: str):
    """
    Parse a line like:

    [.#####.#.#] (0,1,2,3,6,7,8,9) (1,9) ... {74,55,39,73,15,44,44,53,63,37}

    Returns:
        pushes: List[List[int]]
        goal:   List[int]
    """
    line = line.strip()
    if not line:
        return None, None

    parts = line.split()
    if len(parts) < 2:
        raise ValueError(f"Unexpected line format: {line!r}")

    # parts[0] is the pattern in [ ... ] – we don't need it for solving
    # parts[1:-1] are the button definitions: "(...)" tokens
    # parts[-1]   is the goal: "{...}"
    push_tokens = parts[1:-1]
    jolts_token = parts[-1]

    # Parse pushes
    pushes = []
    for tok in push_tokens:
        tok = tok.strip()
        if not tok.startswith("(") or not tok.endswith(")"):
            raise ValueError(f"Expected button in parentheses, got: {tok!r}")
        inside = tok[1:-1].strip()
        if not inside:
            pushes.append([])
        else:
            pushes.append([int(x) for x in inside.split(",")])

    # Parse goal joltages
    jolts_token = jolts_token.strip()
    if not jolts_token.startswith("{") or not jolts_token.endswith("}"):
        raise ValueError(f"Expected goal in braces, got: {jolts_token!r}")
    inside = jolts_token[1:-1].strip()
    goal = [] if not inside else [int(x) for x in inside.split(",")]

    return pushes, goal


def solve_joltage(goal, pushes):
    """
    Use Z3 to solve:

      For each counter i:
          sum_{j where i in pushes[j]} x_j == goal[i]

      with x_j >= 0 integers, and minimize sum(x_j).

    Returns:
        (total_presses: int, per_button: List[int])
    """
    n = len(goal)      # number of counters
    m = len(pushes)    # number of buttons

    opt = Optimize()

    # Int variable per button: how many times topress it
    x = [Int(f"x_{j}") for j in range(m)]

    # Non-negative constraint
    for j in range(m):
        opt.add(x[j] >= 0)

    # Constraints per counter
    for i in range(n):
        affecting = []
        for j in range(m):
            if i in pushes[j]:
                affecting.append(x[j])

        if not affecting:
            # No button affects this counter; it can only be 0
            opt.add(goal[i] == 0)
        else:
            opt.add(Sum(affecting) == goal[i])

    # Objective: minimize total presses
    total_presses = Sum(x)
    opt.minimize(total_presses)

    # Solve
    res = opt.check()
    if res != sat:
        raise RuntimeError(f"No solution for goal={goal}, pushes={pushes}")

    model = opt.model()
    per_button = [model[v].as_long() for v in x]
    total = sum(per_button)

    # Optional sanity check: recompute counters
    for i in range(n):
        s = 0
        for j in range(m):
            if i in pushes[j]:
                s += per_button[j]
        if s != goal[i]:
            raise RuntimeError(
                f"Model verification failed at counter {i}: got {s}, expected {goal[i]}"
            )

    return total, per_button


def main():
    input_path = "10_input.txt"
    total_count = 0

    with open(input_path, "r", encoding="utf-8") as f:
        for line in f:
            if not line.strip():
                break

            pushes, goal = parse_line(line)
            if pushes is None:
                continue

            row_total, per_button = solve_joltage(goal, pushes)
            print(f"Row goal {goal} -> presses {row_total}, per button {per_button}")
            total_count += row_total

    print(f"\n>> total presses over all rows: {total_count}")


if __name__ == "__main__":
    main()
