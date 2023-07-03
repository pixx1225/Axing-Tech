Leetcode题库

1. 两数之和

给定一个整数数组 `nums` 和一个整数目标值 `target`，请你在该数组中找出 **和为目标值** *`target`* 的那 **两个** 整数，并返回它们的数组下标。

```java
public static int[] twoSum(int[] nums, int target) {
    int[] index = new int[2];
    for (int i = 0; i < nums.length; i++) {
        for (int j = i + 1; j < nums.length; j++) {
            if (nums[i] + nums[j] == target) {
                index[0] = i;
                index[1] = j;
            }
        }
    }
    return index;
}
```

2. 两数相加

给你两个 **非空** 的链表，表示两个非负的整数。它们每位数字都是按照 **逆序** 的方式存储的，并且每个节点只能存储 **一位** 数字。请你将两个数相加，并以相同形式返回一个表示和的链表。你可以假设除了数字 0 之外，这两个数都不会以 0 开头。

```java
//小技巧：对于链表问题，返回结果为头结点时，通常需要先初始化一个预先指针 pre，该指针的下一个节点指向真正的头结点 head。使用预先指针的目的在于链表初始化时无可用节点值，而且链表构造过程需要指针移动，进而会导致头指针丢失，无法返回结果。
public static ListNode addTwoNumbers(ListNode l1, ListNode l2) {
    ListNode pre = new ListNode(0);
    ListNode cur = pre;
    int carry = 0;
    while(l1 != null || l2 != null) {
        int x = l1 == null ? 0 : l1.val;
        int y = l2 == null ? 0 : l2.val;
        int sum = x + y + carry;

        carry = sum / 10;
        sum = sum % 10;
        cur.next = new ListNode(sum);

        cur = cur.next;
        if(l1 != null)
            l1 = l1.next;
        if(l2 != null)
            l2 = l2.next;
    }
    if(carry == 1) {
        cur.next = new ListNode(carry);
    }
    return pre.next;
}
```

```java
//暴力解法
public static ListNode addTwoNumbers(ListNode l1, ListNode l2) {
    String num1str = String.valueOf(l1.val);
    while (l1.next != null) {
        num1str += String.valueOf(l1.next.val);
        l1 = l1.next;
    }
    StringBuilder sb = new StringBuilder(num1str);
    int num1 = Integer.parseInt(sb.reverse().toString());

    String num2str = String.valueOf(l2.val);
    while (l2.next != null) {
        num2str += String.valueOf(l2.next.val);
        l2 = l2.next;
    }
    StringBuilder sb2 = new StringBuilder(num2str);
    int num2 = Integer.parseInt(sb2.reverse().toString());

    int sum = num1 + num2;
    StringBuilder sb3 = new StringBuilder(String.valueOf(sum));
    String sumstr = sb3.reverse().toString();
    ListNode ln = new ListNode(0);
    ListNode cur = ln;
    for (int i = 0; i < sumstr.length(); i++) {
        cur.next = new ListNode(Integer.parseInt(String.valueOf(sumstr.charAt(i))));
        cur = cur.next;
    }
    return ln.next;
}
```

3. 无重复字符的最长子串

给定一个字符串 `s` ，请你找出其中不含有重复字符的 **最长子串** 的长度。

