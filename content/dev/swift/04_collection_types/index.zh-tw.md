---
draft : true
title: "[從C#到Swift] 04. Collection Types"
date : 2026-01-25
tags : ["Swift", "C#"]
categories : ["From C# to Swift"]
description : "深入解析 Swift 的三大集合類型：Array、Set 與 Dictionary。本文專為 C# 開發者撰寫，重點比較 Swift 的 Value Type 特性與 C# Reference Type 的差異，並詳細介紹語法對照、記憶體管理行為與常見陷阱。"
keywords : ["Swift vs C#", "iOS Development", "Swift Array vs C# List", "Swift Dictionary vs C# Dictionary"]
featureImage : "conver.jpg"
featureImageDescription : "Swift 集合類型 Array, Set, Dictionary 的抽象視覺圖"
slug : "from-csharp-to-swift/collection-types"
---

![](cover.jpg)


**從 C# 視角學習 Swift**  <br>
> [Swift : Collection Types](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/collectiontypes)



## 集合類型的可變性 (Mutability of Collections)

### 1. 核心觀念
* **概念解說**：在 Swift 中，集合（Arrays, Sets, Dictionaries）的可變性完全取決於它們是被宣告為變數（`var`）還是常數（`let`）。這與集合本身的類型定義無關，而是由宣告方式決定。
* **關鍵語法**：`var` (Mutable), `let` (Immutable)
* **官方提示**：
> 建立不可變的集合（Immutable collections）是一個好的實踐習慣。這不僅讓程式邏輯更清晰，Swift 編譯器也能針對不可變集合進行效能最佳化。

### 2. 範例解析
**文件原始碼**：
```swift
// 如果宣告為 var，集合可以在創建後被修改（新增、刪除、變更項目）
var mutableArray = [1, 2, 3]
mutableArray.append(4) 

// 如果宣告為 let，集合的大小和內容都不能改變
let immutableArray = [1, 2, 3]
// immutableArray.append(4) // 這行會報錯
```
**邏輯解說**：這段程式碼展示了 `var` 賦予了集合修改內容的能力，而 `let` 則完全鎖定了集合的內容與長度。

### 3. C# 開發者視角

**概念對應**：C# 的 `readonly` 關鍵字與 Swift 的 `let` 行為有本質上的不同。

**C# 對照程式碼**：
```csharp
// C#
public class CollectionExample {
    // 即使是 readonly，List 的內容依然可以被修改
    public readonly List<int> numbers = new List<int> { 1, 2, 3 };

    public void Modify() {
        numbers.Add(4); // 在 C# 這是合法的！readonly 只保護 reference 不被重新指派
    }
}
```

**關鍵差異分析**：
*   **語法面**：Swift 的 `let` 宣告集合時，是真正意義上的「完全不可變」（Deep Immutability）。
*   **行為面**：這是因為 Swift 的集合類型是 **Struct (Value Type)**，而 C# 的集合是 **Class (Reference Type)**。在 Swift 中，當你把 Array 指派給 `let`，代表這個 Value Type 的實體完全不能被更動；而在 C# 中，`readonly List` 僅代表你不能將變數指向另一個 List 物件，但原本 List 內部的資料是可以被修改的。若要在 C# 達到 Swift `let` 的效果，通常需要使用 `ImmutableList<T>` 或 `ReadOnlyCollection<T>`。

---

## 陣列 (Arrays)

### 1. 核心觀念
* **概念解說**：Array 是有序的清單，允許儲存重複的值。Swift 的 Array 是一個泛型集合。
* **關鍵語法**：`[Element]`, `Array<Element>`, `append`, `+=`, Subscript syntax `[]`
* **官方提示**：
> Swift 的 Array 類型與 Foundation 的 NSArray 類別有橋接（Bridged）關係。

### 2. 範例解析
**文件原始碼**：
```swift
// 簡寫語法與初始化
var shoppingList: [String] = ["Eggs", "Milk"]

// 使用 append 新增
shoppingList.append("Flour")

// 使用 += 連接陣列
shoppingList += ["Baking Powder", "Chocolate Spread", "Cheese", "Butter"]

// 使用 Range Subscript 修改範圍內的值
shoppingList[4...6] = ["Bananas", "Apples"] 
// 把 index 4 到 6 的三個元素替換成兩個新元素
```
**邏輯解說**：
1.  Swift 偏好使用 `[Type]` 的簡寫語法。
2.  `+=` 運算子可以用來串接陣列，非常直觀。
3.  最強大的是 `Range Subscript`，可以直接替換陣列中的一段範圍，且替換的新內容長度不一定要等於原本範圍的長度（如範例中用 2 個元素替換了 3 個元素）。

### 3. C# 開發者視角

**概念對應**：Swift 的 `Array` 對應到 C# 的 `List<T>`，而不是 C# 的原始陣列 `T[]`。

**C# 對照程式碼**：
```csharp
// C#
var shoppingList = new List<string> { "Eggs", "Milk" };
shoppingList.Add("Flour");
shoppingList.AddRange(new [] { "Baking Powder", "Chocolate Spread" });

// C# List 沒有原生的 Range Assignment 語法，通常需要 RemoveRange + InsertRange
shoppingList.RemoveRange(4, 3);
shoppingList.InsertRange(4, new [] { "Bananas", "Apples" });
```

**關鍵差異分析**：
*   **語法面**：Swift 的 `+=` 用於陣列串接比 C# 的 `AddRange` 更簡潔。Swift 的 Range Subscript (`[4...6] = ...`) 是 C# 開發者會非常羨慕的功能。
*   **行為面**：**這是最大的陷阱**。Swift 的 Array 是 **Value Type**，C# 的 `List<T>` 是 **Reference Type**。
    *   在 Swift：`var a = [1]; var b = a; b.append(2);` -> `a` 還是 `[1]`，只有 `b` 變了（Copy-on-Write 機制）。
    *   在 C#：`var a = new List<int>{1}; var b = a; b.Add(2);` -> `a` 也會變成 `[1, 2]`，因為它們指向同一個物件。

---

## 集合 (Sets)

### 1. 核心觀念
* **概念解說**：Set 是無序且元素唯一的集合。存入 Set 的類型必須遵循 `Hashable` 協定，以便計算雜湊值來確認唯一性。
* **關鍵語法**：`Set<Element>`, `insert`, `intersection`, `union`, `symmetricDifference`

### 2. 範例解析
**文件原始碼**：
```swift
var favoriteGenres: Set<String> = ["Rock", "Classical", "Hip hop"]

// 集合運算
let oddDigits: Set<Int> = [1, 3, 5, 7, 9]
let evenDigits: Set<Int> = [0, 2, 4, 6, 8]

// 交集
oddDigits.intersection(evenDigits).sorted() // []
// 聯集
oddDigits.union(evenDigits).sorted() // [0, 1, ..., 9]
```
**邏輯解說**：Swift 將集合運算（交集、聯集、差集）作為 Set 的核心方法直接提供，並且語法非常貼近數學定義。

### 3. C# 開發者視角

**概念對應**：對應 C# 的 `HashSet<T>`。

**C# 對照程式碼**：
```csharp
// C#
var favoriteGenres = new HashSet<string> { "Rock", "Classical", "Hip hop" };

var oddDigits = new HashSet<int> { 1, 3, 5, 7, 9 };
var evenDigits = new HashSet<int> { 0, 2, 4, 6, 8 };

// C# 的 HashSet 會直接修改自身 (UnionWith, IntersectWith)
// 若要產生新集合需使用 LINQ 或複製建構子
var union = new HashSet<int>(oddDigits);
union.UnionWith(evenDigits);
```

**關鍵差異分析**：
*   **語法面**：Swift 的 `Set` 初始化時沒有簡寫語法（如 `[Type]` 之於 Array），必須寫 `Set<Type>`，但可以用 Array Literal `[]` 來賦值。
*   **行為面**：Swift 的集合運算方法（如 `union`）通常會返回一個**新的 Set**（Functional style），而 C# 的 `HashSet` 方法（如 `UnionWith`）通常是 `void` 並修改當前實例（Imperative style）。若要在 Swift 中修改自身，需使用 `formUnion` 等帶有 `form` 前綴的方法。

---

## 字典 (Dictionaries)

### 1. 核心觀念
* **概念解說**：儲存 Key-Value 對應關係的無序集合。Key 必須是 `Hashable`。
* **關鍵語法**：`[Key: Value]`, `updateValue`, `removeValue`, Subscript key access
* **官方提示**：
> 使用 Subscript 語法存取字典時，回傳的是一個 Optional 值，因為該 Key 可能不存在。

### 2. 範例解析
**文件原始碼**：
```swift
var airports: [String: String] = ["YYZ": "Toronto Pearson", "DUB": "Dublin"]

// 新增或修改
airports["LHR"] = "London"

// 使用 updateValue 可以取得舊值
if let oldValue = airports.updateValue("Dublin Airport", forKey: "DUB") {
    print("Old value was \(oldValue)")
}

// 存取值（回傳 Optional）
if let airportName = airports["DUB"] {
    print("Airport is \(airportName)")
} else {
    print("Not found")
}

// 移除
airports["APL"] = nil // 設為 nil 即移除
```
**邏輯解說**：
1.  `[Key: Value]` 是標準簡寫。
2.  `updateValue` 很有用，它在更新同時會回傳「更新前的值」，適合用來做 Log 或邏輯判斷。
3.  將某個 Key 的值設為 `nil`，等同於從字典中刪除該 Key。

### 3. C# 開發者視角

**概念對應**：對應 C# 的 `Dictionary<TKey, TValue>`。

**C# 對照程式碼**：
```csharp
// C#
var airports = new Dictionary<string, string> {
    { "YYZ", "Toronto Pearson" },
    { "DUB", "Dublin" }
};

// 存取值 - C# 的索引器若 Key 不存在會拋出 Exception
// string name = airports["INVALID"]; // Throws KeyNotFoundException

// 安全存取方式
if (airports.TryGetValue("DUB", out string airportName)) {
    Console.WriteLine($"Airport is {airportName}");
}

// 移除
airports.Remove("APL"); // 不能賦值 null 來移除
```

**關鍵差異分析**：
*   **語法面**：
    *   Swift 的索引存取 `dict[key]` **永遠回傳 Optional**，這迫使開發者處理 Key 不存在的情況（更安全）。
    *   C# 的索引存取 `dict[key]` 假設 Key 存在，否則拋出例外。C# 開發者必須習慣使用 `TryGetValue` 或是 Swift 的 Optional Binding (`if let`)。
*   **行為面**：
    *   在 Swift 中，`dict["key"] = nil` 是刪除操作。
    *   在 C# 中，如果 Value Type 是 Reference Type，`dict["key"] = null` 只是把該 Value 設為 null，Key 依然存在於字典中。這是非常容易混淆的點。
    *   **迭代 (Iteration)**：Swift 迭代字典時拿到的是 Tuple `(key, value)`，非常方便解構；C# 拿到的是 `KeyValuePair<TKey, TValue>` 物件，需存取 `.Key` 和 `.Value` 屬性。

```swift
// Swift 迭代
for (code, name) in airports {
    print("\(code): \(name)")
}
```

```csharp
// C# 迭代
foreach (var kvp in airports) {
    Console.WriteLine($"{kvp.Key}: {kvp.Value}");
}
```