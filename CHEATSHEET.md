# DSA Cheatsheet (Python)

Quick reference for the NeetCode 150 patterns. Read the "Spot it" line first, then the template.

---

## 1. What complexity can I afford?

LeetCode allows roughly 10⁷–10⁸ simple operations, so use the input size to guess the intended solution.

| Input size `n` | Target complexity | Usually means |
|---|---|---|
| ≤ 10–12 | O(n!), O(2ⁿ · n) | Backtracking, permutations |
| ≤ 20–25 | O(2ⁿ) | Subsets, bitmask |
| ≤ 500 | O(n³) | 3 nested loops, interval DP |
| ≤ 5,000 | O(n²) | 2D DP, all pairs |
| ≤ 10⁵–10⁶ | O(n log n) or O(n) | Sort, heap, binary search, two pointers, hashing |
| ≥ 10⁹ (a value, not a length) | O(log n) | Binary search, math |

## 2. Data structure costs

| Structure (Python) | Access | Search | Insert | Delete | Notes |
|---|---|---|---|---|---|
| `list` | O(1) | O(n) | O(1) at end, O(n) middle | O(1) `pop()`, O(n) `pop(0)` | Never `pop(0)` in a loop, use `deque` |
| `dict` / `set` | — | O(1) avg | O(1) avg | O(1) avg | Keys must be hashable (tuple yes, list no) |
| `collections.deque` | O(1) ends | O(n) | O(1) both ends | O(1) both ends | Queues, BFS, sliding window max |
| `heapq` (min-heap) | O(1) min | O(n) | O(log n) | O(log n) pop min | Max-heap: push `-x` |
| Sorted list + `bisect` | O(1) | O(log n) | O(n) | O(n) | Binary search on sorted data |
| String | O(1) | O(n) | — | — | Immutable: `s += c` in a loop is O(n²), build a list and `"".join()` |

Sorting: `sort()` / `sorted()` is O(n log n) time, O(n) space.

## 3. Python toolkit

```python
from collections import Counter, defaultdict, deque
import heapq, bisect, math

Counter("aabc")                 # {'a': 2, 'b': 1, 'c': 1}
Counter(nums).most_common(k)    # k most frequent (value, count) pairs
groups = defaultdict(list)      # groups[key].append(x), no KeyError
q = deque([start]); q.popleft() # O(1) queue
heapq.heappush(h, (priority, item)); heapq.heappop(h)
heapq.heapify(arr)              # O(n), in place
bisect.bisect_left(arr, x)      # first index with arr[i] >= x
bisect.bisect_right(arr, x)     # first index with arr[i] > x
nums.sort(key=lambda x: (x[0], -x[1]))   # sort by first asc, second desc
float("inf"), float("-inf")
divmod(a, b)                    # (a // b, a % b)
ord("c") - ord("a")             # 2: letter -> index 0..25
enumerate(nums), zip(a, b), reversed(nums)
grid = [[0] * cols for _ in range(rows)]  # NOT [[0] * cols] * rows (shared rows!)
```

Recursion depth is 1000 by default. For deep DFS add `sys.setrecursionlimit(10**6)` or write it iteratively.

## 4. Spot the pattern

| If the problem says / has… | Think |
|---|---|
| "seen before", duplicates, counts, anagrams | Hash map / set |
| Sorted array, pair / triplet with a sum | Two pointers |
| Longest / shortest **contiguous** subarray or substring | Sliding window |
| "next greater / smaller", matching brackets | Stack / monotonic stack |
| Sorted input, or "minimum X such that…" | Binary search (on index or on answer) |
| Linked list cycle, middle, k-th from end | Fast & slow pointers |
| Tree: depth, path, subtree | DFS (recursion) |
| Tree: level by level, nearest | BFS (queue) |
| Prefix matching, word search with many words | Trie |
| "k-th largest", "top k", merge k sorted, running median | Heap |
| All combinations / permutations / subsets | Backtracking |
| Grid of islands, connected components | DFS / BFS / Union-Find |
| Prerequisites, ordering, dependencies | Topological sort |
| Shortest path, unweighted | BFS |
| Shortest path, weighted (non-negative) | Dijkstra |
| "number of ways", "min / max cost", choices at each step | Dynamic programming |
| Locally best choice works (jumps, gas station) | Greedy |
| Overlapping ranges, meetings | Sort intervals by start |
| "without extra space", XOR, single number, powers of 2 | Bit manipulation |

---

## 5. Templates

### Arrays & Hashing

```python
# Frequency count / "have I seen it?"
seen = {}
for i, x in enumerate(nums):
    if target - x in seen:          # Two Sum: check BEFORE inserting
        return [seen[target - x], i]
    seen[x] = i

# Group by a canonical key (Group Anagrams)
groups = defaultdict(list)
for w in words:
    groups[tuple(sorted(w))].append(w)   # or a 26-length count tuple

# Prefix sums: sum(nums[i:j]) == pre[j] - pre[i]
pre = [0]
for x in nums:
    pre.append(pre[-1] + x)

# Subarray sum equals k: count prefix sums seen so far
count, cur, seen = 0, 0, {0: 1}
for x in nums:
    cur += x
    count += seen.get(cur - k, 0)
    seen[cur] = seen.get(cur, 0) + 1
```

Bucket sort (Top K Frequent): index = frequency, at most `len(nums)` buckets, O(n).

### Two Pointers

```python
# Opposite ends on a sorted array (Two Sum II, Container With Most Water)
l, r = 0, len(nums) - 1
while l < r:
    s = nums[l] + nums[r]
    if s == target:
        return [l, r]
    elif s < target:
        l += 1
    else:
        r -= 1

# 3Sum: sort, fix i, two-pointer the rest, skip duplicates
nums.sort()
for i in range(len(nums)):
    if i > 0 and nums[i] == nums[i - 1]:
        continue
    l, r = i + 1, len(nums) - 1
    # ...two-pointer; after a hit: l += 1, and while l < r and nums[l] == nums[l-1]: l += 1
```

Container With Most Water: always move the **shorter** side, the taller one can't improve the area.

### Sliding Window

```python
# Variable window: longest substring with some condition
window = {}
l = best = 0
for r, c in enumerate(s):
    window[c] = window.get(c, 0) + 1
    while window_is_invalid(window):   # e.g. window[c] > 1 for "no repeats"
        window[s[l]] -= 1
        l += 1
    best = max(best, r - l + 1)

# Fixed window of size k
cur = sum(nums[:k]); best = cur
for r in range(k, len(nums)):
    cur += nums[r] - nums[r - k]
    best = max(best, cur)
```

Longest Repeating Character Replacement: valid while `window_len - max_freq <= k`.

### Stack

```python
# Valid parentheses
pairs = {")": "(", "]": "[", "}": "{"}
stack = []
for c in s:
    if c in pairs:
        if not stack or stack.pop() != pairs[c]:
            return False
    else:
        stack.append(c)
return not stack

# Monotonic decreasing stack: next greater element / Daily Temperatures
res = [0] * len(temps)
stack = []                          # holds indices, values decreasing
for i, t in enumerate(temps):
    while stack and temps[stack[-1]] < t:
        j = stack.pop()
        res[j] = i - j
    stack.append(i)
```

### Binary Search

```python
# Exact match
l, r = 0, len(nums) - 1
while l <= r:
    m = (l + r) // 2
    if nums[m] == target:
        return m
    elif nums[m] < target:
        l = m + 1
    else:
        r = m - 1
return -1

# Binary search on the answer: smallest x where ok(x) is True
# (Koko Eating Bananas, Capacity to Ship Packages)
l, r = lo, hi
while l < r:
    m = (l + r) // 2
    if ok(m):
        r = m          # m might be the answer, keep it
    else:
        l = m + 1
return l
```

Rotated sorted array: one half is always sorted. Check which half, then check if the target lies inside it.

### Linked List

```python
# Reverse
prev, cur = None, head
while cur:
    cur.next, prev, cur = prev, cur, cur.next
return prev

# Fast & slow: middle / cycle
slow = fast = head
while fast and fast.next:
    slow, fast = slow.next, fast.next.next
    if slow is fast:
        return True     # cycle
# when the loop ends without a cycle, slow is the middle

# Dummy head: avoids special cases when the head can change
dummy = tail = ListNode(0)
# ...tail.next = node; tail = tail.next
return dummy.next
```

Remove N-th from end: move `fast` n steps ahead, then move both until `fast.next` is None.

### Trees

```python
# DFS: most tree problems are "answer = combine(left, right)"
def depth(node):
    if not node:
        return 0
    return 1 + max(depth(node.left), depth(node.right))

# BFS level order
q = deque([root]) if root else deque()
levels = []
while q:
    level = []
    for _ in range(len(q)):         # process exactly one level
        node = q.popleft()
        level.append(node.val)
        if node.left: q.append(node.left)
        if node.right: q.append(node.right)
    levels.append(level)

# Validate BST: pass down the allowed range
def valid(node, lo=float("-inf"), hi=float("inf")):
    if not node:
        return True
    if not lo < node.val < hi:
        return False
    return valid(node.left, lo, node.val) and valid(node.right, node.val, hi)
```

- Inorder traversal of a BST is sorted (k-th smallest).
- "Max path / diameter": the DFS returns the best *one-sided* path, and you update a global answer with `left + right`.
- LCA in a BST: both values smaller, go left; both bigger, go right; otherwise this node is the answer.

### Tries

```python
class Trie:
    def __init__(self):
        self.root = {}

    def insert(self, word):
        node = self.root
        for c in word:
            node = node.setdefault(c, {})
        node["$"] = True            # end-of-word marker

    def search(self, word, prefix=False):
        node = self.root
        for c in word:
            if c not in node:
                return False
            node = node[c]
        return prefix or "$" in node
```

### Heap / Priority Queue

```python
# k-th largest: keep a min-heap of size k, its top is the answer
h = []
for x in nums:
    heapq.heappush(h, x)
    if len(h) > k:
        heapq.heappop(h)
return h[0]

# Max-heap: negate
heapq.heappush(h, -x); largest = -heapq.heappop(h)
```

Median from a data stream: max-heap for the lower half, min-heap for the upper half, keep their sizes within 1.

### Backtracking

```python
# Subsets / combinations: choose, explore, un-choose
res, path = [], []
def backtrack(start):
    res.append(path[:])             # copy! path keeps changing
    for i in range(start, len(nums)):
        if i > start and nums[i] == nums[i - 1]:
            continue                # skip duplicates (sort nums first)
        path.append(nums[i])
        backtrack(i + 1)            # i + 1: each element once; i: reuse allowed (Combination Sum)
        path.pop()
backtrack(0)

# Permutations
def permute(path, used):
    if len(path) == len(nums):
        res.append(path[:]); return
    for i in range(len(nums)):
        if not used[i]:
            used[i] = True; path.append(nums[i])
            permute(path, used)
            used[i] = False; path.pop()
```

### Graphs

```python
# Grid DFS (Number of Islands)
def dfs(r, c):
    if r < 0 or c < 0 or r >= R or c >= C or grid[r][c] != "1":
        return
    grid[r][c] = "0"                # mark visited
    for dr, dc in ((1, 0), (-1, 0), (0, 1), (0, -1)):
        dfs(r + dr, c + dc)

# BFS shortest path (unweighted) / multi-source BFS (Rotting Oranges)
q = deque(starts)                   # push ALL sources first for multi-source
dist = {s: 0 for s in starts}
while q:
    node = q.popleft()
    for nxt in adj[node]:
        if nxt not in dist:
            dist[nxt] = dist[node] + 1
            q.append(nxt)

# Topological sort, Kahn's algorithm (Course Schedule)
indeg = [0] * n
adj = defaultdict(list)
for a, b in edges:                  # b must come before a
    adj[b].append(a); indeg[a] += 1
q = deque(i for i in range(n) if indeg[i] == 0)
order = []
while q:
    node = q.popleft(); order.append(node)
    for nxt in adj[node]:
        indeg[nxt] -= 1
        if indeg[nxt] == 0:
            q.append(nxt)
has_cycle = len(order) < n

# Union-Find (Redundant Connection, Number of Components)
parent = list(range(n))
def find(x):
    while parent[x] != x:
        parent[x] = parent[parent[x]]   # path compression
        x = parent[x]
    return x
def union(a, b):
    ra, rb = find(a), find(b)
    if ra == rb:
        return False                # already connected -> this edge makes a cycle
    parent[ra] = rb
    return True
```

### Advanced Graphs

```python
# Dijkstra: shortest path with non-negative weights, O(E log V)
dist = {src: 0}
h = [(0, src)]
while h:
    d, node = heapq.heappop(h)
    if d > dist.get(node, float("inf")):
        continue                    # stale entry
    for nxt, w in adj[node]:
        nd = d + w
        if nd < dist.get(nxt, float("inf")):
            dist[nxt] = nd
            heapq.heappush(h, (nd, nxt))
```

- **Prim's MST** (Min Cost to Connect Points): same as Dijkstra, but push `(edge_weight, node)` instead of total distance.
- **Bellman-Ford** (Cheapest Flights Within K Stops): relax all edges k+1 times, copying `dist` each round.

### 1-D Dynamic Programming

Recipe: **1)** define `dp[i]` in words, **2)** write the recurrence, **3)** set base cases, **4)** pick the loop order, **5)** squeeze space if only the last few values are used.

```python
# Climbing Stairs / Fibonacci shape: dp[i] = dp[i-1] + dp[i-2]
a, b = 1, 1
for _ in range(n - 1):
    a, b = b, a + b
return b

# House Robber: dp[i] = max(dp[i-1], dp[i-2] + nums[i])
prev2 = prev1 = 0
for x in nums:
    prev2, prev1 = prev1, max(prev1, prev2 + x)
return prev1

# Coin Change (unbounded): dp[a] = min coins to make amount a
dp = [0] + [float("inf")] * amount
for a in range(1, amount + 1):
    for c in coins:
        if c <= a:
            dp[a] = min(dp[a], dp[a - c] + 1)
return dp[amount] if dp[amount] != float("inf") else -1

# Longest Increasing Subsequence in O(n log n)
tails = []
for x in nums:
    i = bisect.bisect_left(tails, x)
    if i == len(tails): tails.append(x)
    else: tails[i] = x
return len(tails)
```

Top-down is often easier to write first: a recursive function plus `@functools.lru_cache(None)`.

### 2-D Dynamic Programming

```python
# Grid paths: dp[r][c] = dp[r-1][c] + dp[r][c-1]
# Longest Common Subsequence
dp = [[0] * (len(b) + 1) for _ in range(len(a) + 1)]
for i in range(1, len(a) + 1):
    for j in range(1, len(b) + 1):
        if a[i - 1] == b[j - 1]:
            dp[i][j] = dp[i - 1][j - 1] + 1
        else:
            dp[i][j] = max(dp[i - 1][j], dp[i][j - 1])
return dp[-1][-1]

# 0/1 knapsack (Partition Equal Subset Sum): loop capacity BACKWARDS
dp = [True] + [False] * target
for x in nums:
    for t in range(target, x - 1, -1):
        dp[t] = dp[t] or dp[t - x]
```

- Edit Distance: `dp[i][j] = 1 + min(insert, delete, replace)` when the chars differ.
- **0/1 knapsack** (each item once): loop capacity backwards. **Unbounded** (reuse allowed): loop forwards.

### Greedy

```python
# Kadane: max subarray sum
best = cur = nums[0]
for x in nums[1:]:
    cur = max(x, cur + x)           # extend, or start fresh
    best = max(best, cur)

# Jump Game: track the farthest index reachable
far = 0
for i, j in enumerate(nums):
    if i > far:
        return False
    far = max(far, i + j)
return True
```

### Intervals

```python
# Merge intervals
intervals.sort(key=lambda x: x[0])
merged = [intervals[0]]
for s, e in intervals[1:]:
    if s <= merged[-1][1]:          # overlaps
        merged[-1][1] = max(merged[-1][1], e)
    else:
        merged.append([s, e])
```

- Two intervals overlap when `a.start <= b.end and b.start <= a.end`.
- Minimum removals to stop overlaps: sort by **end**, keep the interval that ends first.
- Meeting Rooms II: a min-heap of end times; its size is the number of rooms needed.

### Math & Geometry

- Rotate a matrix 90° clockwise: transpose, then reverse each row.
- Spiral matrix: shrink `top`, `bottom`, `left` and `right` bounds after each side.
- Fast power: `pow(x, n)` in O(log n) by squaring; handle `n < 0` with `1 / x`.
- Detect a cycle in a number sequence (Happy Number): use a set, or fast & slow.

### Bit Manipulation

```python
x & 1            # is x odd?
x & (x - 1)      # drop the lowest set bit -> x is a power of 2 if result is 0 (and x > 0)
x & -x           # keep only the lowest set bit
a ^ a == 0       # and a ^ 0 == a: XOR all numbers, pairs cancel, the single number remains
(x >> i) & 1     # i-th bit
bin(x).count("1")
```

Python ints never overflow. For 32-bit problems, mask with `& 0xFFFFFFFF`.

---

## 6. In the interview (or before you hit Submit)

1. **Repeat the problem** in your own words and confirm the input sizes.
2. **Walk through an example** by hand, plus edge cases: empty, one element, duplicates, negatives, all equal.
3. **Say the brute force** and its complexity first, then improve it.
4. **Name the pattern** from the table in section 4 before writing code.
5. **Code it**, then **dry-run** one example line by line.
6. **State time and space complexity** and put them in the file header.
