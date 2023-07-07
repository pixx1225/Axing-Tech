[TOC]

# Leetcode题库

### 1.两数之和

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

### 2.两数相加

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

### 3.无重复字符的最长子串

给定一个字符串 `s` ，请你找出其中不含有重复字符的 **最长子串** 的长度。

```java
//滑动窗口，移动方法把队列的左边的元素移出就行
public int lengthOfLongestSubstring(String s) {
    if (s.length() == 0) {
        return 0;
    }
    HashMap<Character, Integer> map = new HashMap<>();
    int max = 0;
    int left = 0;
    for (int i = 0; i < s.length(); i++) {
        if (map.containsKey(s.charAt(i))) {
            //将left移到最右边使得窗口最小
            left = Math.max(left, map.get(s.charAt(i)) + 1);
        }
        map.put(s.charAt(i), i);
        max = Math.max(max, i - left + 1);
    }
    return max;
}
```

### 4.寻找两个正序数组的中位数

给定两个大小分别为 `m` 和 `n` 的正序（从小到大）数组 `nums1` 和 `nums2`。请你找出并返回这两个正序数组的 **中位数** 。算法的时间复杂度应该为 `O(log (m+n))` 。

```java
//暴力解决，将两个数组合并
public double findMedianSortedArrays(int[] nums1, int[] nums2) {
    int m = nums1.length;
    int n = nums2.length;
    int[] nums = new int[m + n];
    if (m == 0) {
        if (n % 2 == 0) {
            return (nums2[n / 2 - 1] + nums2[n / 2]) / 2.0;
        } else {
            return nums2[n / 2];
        }
    }
    if (n == 0) {
        if (m % 2 == 0) {
            return (nums1[m / 2 - 1] + nums1[m / 2]) / 2.0;
        } else {
            return nums1[m / 2];
        }
    }
    int nums1index = 0;
    int nums2index = 0;
    for (int i = 0; i < nums.length; i++) {
        if (nums1index < m && nums2index < n) {
            if (nums1[nums1index] < nums2[nums2index]) {
                nums[i] = nums1[nums1index];
                nums1index++;
            } else {
                nums[i] = nums2[nums2index];
                nums2index++;
            }
        } else if (nums1index < m) {
            nums[i] = nums1[nums1index];
            nums1index++;
        } else if (nums2index < n) {
            nums[i] = nums2[nums2index];
            nums2index++;
        }
    }

    int count = m + n;
    if (count % 2 == 0) {
        return (nums[count / 2 - 1] + nums[count / 2]) / 2.0;
    } else {
        return nums[count / 2];
    }
}
```

### 5.最长回文子串

给你一个字符串 `s`，找到 `s` 中最长的回文子串。

如果字符串的反序与原始字符串相同，则该字符串称为回文字符串。

```java
 public String longestPalindrome(String s) {
        int len = s.length();
        if (len < 2) {
            return s;
        }
        int maxLen = 1;
        int begin = 0;
        char[] charArray = s.toCharArray();
        boolean[][] dp = new boolean[len][len];

        for (int i = 0; i < len; i++) {
            dp[i][i] = true;
        }

        for (int j = 1; j < len; j++) {
            for (int i = 0; i < j; i++) {
                if (charArray[j] != charArray[i]) {
                    dp[i][j] = false;
                } else {
                    if (j - i < 3) {
                        dp[i][j] = true;
                    } else {
                        dp[i][j] = dp[i + 1][j - 1];
                    }
                }
                if (dp[i][j] && j - i + 1 > maxLen) {
                    maxLen = j - i + 1;
                    begin = i;
                }
            }
        }
        return s.substring(begin, begin + maxLen);
    }
}
```

### 6.N 字形变换

将一个给定字符串 `s` 根据给定的行数 `numRows` ，以从上往下、从左到右进行 Z 字形排列。比如输入字符串为 `"PAYPALISHIRING"` 行数为 `3` 时，排列如下：

```
P   A   H   N   0 4 8 12 
A P L S I I G	1 3 5 7 9 11 13
Y   I   R		2 6 10 
```

之后，你的输出需要从左往右逐行读取，产生出一个新的字符串，比如：`"PAHNAPLSIIGYIR"`。

```java
public static String convert2N(String s, int numRows) {
        if (numRows < 2) {
            return s;
        }
        List<StringBuilder> rows = new ArrayList<>();
        for (int i = 0; i < numRows; i++) {
            rows.add(new StringBuilder());
        }
        int i = 0, flag = -1;
        for (char c : s.toCharArray()) {
            rows.get(i).append(c);
            //在达到 Z 字形转折点时，执行反向。
            if (i == 0 || i == numRows - 1) {
                flag = -flag;
            }
            i += flag;
        }
        StringBuilder res = new StringBuilder();
        for (StringBuilder row : rows) {
            res.append(row);
        }
        return res.toString();
    }
```

### 7.整数反转

给你一个 32 位的有符号整数 `x` ，返回将 `x` 中的数字部分反转后的结果。

如果反转后整数超过 32 位的有符号整数的范围 `[−2^31, 2^31 − 1]` ，就返回 0。

```java
public int reverse(int x) {
    int res = 0;
    while(x!=0) {
        //每次取末尾数字
        int tmp = x%10;
        //判断是否 大于 最大32位整数
        if (res>214748364 || (res==214748364 && tmp>7)) {
            return 0;
        }
        //判断是否 小于 最小32位整数
        if (res<-214748364 || (res==-214748364 && tmp<-8)) {
            return 0;
        }
        res = res*10 + tmp;
        x /= 10;
    }
    return res;
}
```

### 9.回文数

给你一个整数 `x` ，如果 `x` 是一个回文整数，返回 `true` ；否则，返回 `false` 。

回文数是指正序（从左向右）和倒序（从右向左）读都是一样的整数。例如，`121` 是回文，而 `123` 不是。

```java
public boolean isPalindrome(int x) {
    if (x < 0) {
        return false;
    }
    StringBuilder sb = new StringBuilder(String.valueOf(x));
    if (sb.reverse().toString().equals(String.valueOf(x))) {
        return true;
    } else {
        return false;
    }
}

public boolean isPalindrome(int x) {
    if (x < 0 || (x % 10 == 0 && x != 0)) return false;
    int rn = 0;
    while (x > rn) {
        rn = rn * 10 + x % 10;
        x /= 10;
    }
    return x == rn || x == rn / 10;
}
```







