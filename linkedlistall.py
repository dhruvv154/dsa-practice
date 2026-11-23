class Node:
    def __init__(self, val):
        self.val = val
        self.next = None

a=Node(10)
b=Node(20)
c=Node(30)

a.next=b
b.next=c
head=a

def print_listhead(head):
    curr = head
    while curr:
        print(curr.val, end="->")
        curr = curr.next
    print("None")


print_listhead(head)




