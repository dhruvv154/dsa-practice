
class Solution(object):
    def characterReplacement(self, s, k):
        count = {}
        left = 0
        max_freq = 0
        result = 0

        for right in range(len(s)):
            # Add current character
            count[s[right]] = count.get(s[right], 0) + 1

            # Update maximum frequency
            max_freq = max(max_freq, count[s[right]])

            # Shrink window if replacements exceed k
            while (right - left + 1) - max_freq > k:
                count[s[left]] -= 1
                left += 1

            # Update answer
            result = max(result, right - left + 1)

        return result
