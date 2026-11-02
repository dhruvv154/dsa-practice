
class Solution(object):
    def topKFrequent(self, nums, k):
        count = {}

        for num in nums:
            if num not in count:
                count[num] = 0
            count[num] += 1

        sorted_nums = sorted(count, key=count.get, reverse=True)

        return sorted_nums[:k]
