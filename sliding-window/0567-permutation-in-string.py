from collections import Counter

class Solution(object):
    def checkInclusion(self, s1, s2):

        if len(s1) > len(s2):
            return False

        count1 = Counter(s1)
        window = Counter(s2[:len(s1)])

        if count1 == window:
            return True

        for i in range(len(s1), len(s2)):

            window[s2[i]] += 1

            left_char = s2[i - len(s1)]
            window[left_char] -= 1

            if window[left_char] == 0:
                del window[left_char]

            if count1 == window:
                return True

        return False