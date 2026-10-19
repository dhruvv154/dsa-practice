# DSA Practice

Daily data structures & algorithms practice, following the [NeetCode 150](https://neetcode.io/practice) roadmap. One problem a day, minimum.

## Layout

Solutions are grouped by topic, in NeetCode 150 order:

| # | Topic | Folder |
|---|-------|--------|
| 1 | Arrays & Hashing | [arrays-hashing](arrays-hashing/) |
| 2 | Two Pointers | [two-pointers](two-pointers/) |
| 3 | Sliding Window | [sliding-window](sliding-window/) |
| 4 | Stack | [stack](stack/) |
| 5 | Binary Search | [binary-search](binary-search/) |
| 6 | Linked List | [linked-list](linked-list/) |
| 7 | Trees | [trees](trees/) |
| 8 | Tries | [tries](tries/) |
| 9 | Heap / Priority Queue | [heap](heap/) |
| 10 | Backtracking | [backtracking](backtracking/) |
| 11 | Graphs | [graphs](graphs/) |
| 12 | Advanced Graphs | [advanced-graphs](advanced-graphs/) |
| 13 | 1-D Dynamic Programming | [1d-dp](1d-dp/) |
| 14 | 2-D Dynamic Programming | [2d-dp](2d-dp/) |
| 15 | Greedy | [greedy](greedy/) |
| 16 | Intervals | [intervals](intervals/) |
| 17 | Math & Geometry | [math-geometry](math-geometry/) |
| 18 | Bit Manipulation | [bit-manipulation](bit-manipulation/) |

Files are named `<leetcode-number>-<slug>.<ext>`, e.g. `0001-two-sum.py`. Each one starts with a short header: problem link, approach, and time/space complexity (see [TEMPLATE.py](TEMPLATE.py)).

## Daily workflow

```powershell
.\new.ps1 arrays-hashing 0001-two-sum      # creates the file from the template
# ...solve it, paste the accepted solution...
.\done.ps1 "Two Sum: hashmap O(n)"         # commit + push
```
