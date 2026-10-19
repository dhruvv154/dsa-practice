class Solution(object):
    def containsDuplicate(self, nums):
        seen=set()

        for num in nums:
            if num in seen:
                return True
            seen.add(num)
        return False

"""Input: nums = [1, 2, 3, 1]
- Original list length = 4
- Set becomes {1, 2, 3}, with length 3
- Since 4 != 3, the answer is True."""