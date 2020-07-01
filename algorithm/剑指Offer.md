[TOC]

# 剑指Offer

## 题一：二维数组中的查找

在一个二维数组中（每个一维数组的长度相同），每一行都按照从左到右递增的顺序排序，每一列都按照从上到下递增的顺序排序。请完成一个函数，输入这样的一个二维数组和一个整数，判断数组中是否含有该整数。

```java
public static boolean findByInt(int target, int [][] array) {
  int rows = array.length;
  int cols = array[0].length;
  for (int i = 0;i<rows;i++){
    int low = 0;
    int high = cols-1;
    while (low<=high){
      int mid = (low+high)/2;
      if(target<array[i][mid]){
        high = mid-1;
      }else if (target>array[i][mid]){
        low = mid+1;
      }else {
        return true;
      }
    }
  }
  return false;
}
```

### 考察点：二分查找

循环实现二分查找

```java
public static int binarySort(int[] array, int key) {
  int low = 0;
  int high = array.length - 1;
  while (low <= high) {
    int mid = (low + high) / 2;
    if (key < array[mid]) {
      high = mid - 1;
    } else if (key > array[mid]) {
      low = mid + 1;
    } else {
      return mid;
    }
  }
  return -1;
}
```

递归实现二分查找

```java
public static int binarySortRecursion(int[] array, int key, int low, int high) {
  if (low <= high) {
    int mid = (low + high) / 2;
    if (key < array[mid]) {
      return binarySortRecursion(array, key, low, mid - 1);
    } else if (key > array[mid]) {
      return binarySortRecursion(array, key, mid + 1, high);
    } else {
      return mid;
    }
  }
  return -1;
}
```

## 题二：替换空格

请实现一个函数，将一个字符串中的每个空格替换成“%20”。例如，当字符串为We Are Happy.则经过替换之后的字符串为We%20Are%20Happy。

```java
public static String replaceSpace(StringBuffer str) {
  return str.toString().replaceAll(" ", "%20");
}
```

## 题三：从尾到头打印链表

输入一个链表，按链表从尾到头的顺序返回一个ArrayList。

方法一：倒序问题用栈Stack，后进先出

```java
 public static ArrayList<Integer> printListFromTailToHead(ListNode listNode) {
   ArrayList<Integer> arrayList = new ArrayList<>();
   Stack<Integer> stack = new Stack<>();
   while (listNode != null) {
     stack.add(listNode.val);
     listNode = listNode.next;
   }

   while (!stack.empty()) {
     arrayList.add(stack.pop());
   }
   return arrayList;
 }
//class ListNode {
//    int val;
//    ListNode next = null;
//
//    ListNode(int val) {
//        this.val = val;
//    }
//}
```

方法二：利用递归

```java
ArrayList<Integer> arrayList=new ArrayList<Integer>();
public ArrayList<Integer> printListFromTailToHead(ListNode listNode) {
  if(listNode!=null){
    this.printListFromTailToHead(listNode.next);
    arrayList.add(listNode.val);
  }
  return arrayList;
}
```

## 题四：重建二叉树