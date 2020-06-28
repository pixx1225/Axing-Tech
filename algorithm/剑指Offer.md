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

