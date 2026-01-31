---
title : "[從C#到Swift] 12. Subscripts"
date : 2026-01-31T12:00:00+08:00
tags : ["Swift", "C#"]
categories : ["From C# to Swift"]
description: "這篇文章將帶領 C# 開發者深入了解 Swift 的下標 (Subscripts) 功能。Swift 的下標對應於 C# 中的索引子 (Indexers)，但提供了更高的靈活性，例如支援多重參數與靜態型別下標 (Type Subscripts)。我們將透過語法對照與範例解析，幫助你掌握其核心用法與關鍵差異。"
keywords: ["Swift vs C#", "iOS Development", "Swift Subscripts", "C# Indexers"]
featureImage: "cover.jpg"
featureImageDescription: "Swift 下標語法的概念示意圖"
slug : "from-csharp-to-swift/subscripts"
---

![](cover.jpg)


**從 C# 視角學習 Swift**  <br>
> [Swift : Subscripts](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/subscripts)


## 下標語法 (Subscript Syntax)

### 1. 核心觀念
* **概念解說**：
  Swift 的 **Subscripts (下標)** 允許你透過中括號 `[]` 快速存取類別 (Class)、結構 (Structure) 或列舉 (Enumeration) 中的成員元素。這就是我們在存取 Array 時使用 `someArray[index]` 或存取 Dictionary 時使用 `someDictionary[key]` 背後的機制。你不需要顯式定義 getX / setX 這類方法，而是由 subscript 統一描述存取行為。
* **關鍵語法**：
  `subscript`, `get`, `set`, `newValue`

### 2. 範例解析
**文件原始碼**：
```swift
struct TimesTable {
    let multiplier: Int
    subscript(index: Int) -> Int {
        return multiplier * index
    }
}
let threeTimesTable = TimesTable(multiplier: 3)
print("six times three is \(threeTimesTable[6])")
// Prints "six times three is 18".
```

**邏輯解說**：
這段程式碼定義了一個名為 `TimesTable` 的結構，用來計算數字的乘法表。
1. 使用 `subscript` 關鍵字定義了下標行為。
2. 這裡省略了 `get` 關鍵字，表示這是一個**唯讀 (Read-Only)** 的下標。
3. 當我們呼叫 `threeTimesTable[6]` 時，Swift 會執行 `subscript` 區塊內的邏輯，回傳 `3 * 6` 的結果。

> **Note**
> 乘法表是基於固定的數學規則，因此將 `threeTimesTable[someIndex]` 設定為新值並不合理，所以此處的 `TimesTable` 下標被定義為唯讀。

### 3. C# 開發者視角

**概念對應**：
Swift 的 `subscript` 直接對應到 C# 的 **索引子 (Indexers)** (`this[...]`)。

**C# 對照程式碼**：
```csharp
public struct TimesTable
{
    private readonly int _multiplier;

    public TimesTable(int multiplier)
    {
        _multiplier = multiplier;
    }

    // C# Indexer
    public int this[int index]
    {
        get { return _multiplier * index; }
        // 唯讀，所以不實作 set
    }
}

var threeTimesTable = new TimesTable(3);
Console.WriteLine($"six times three is {threeTimesTable[6]}");
```

**關鍵差異分析**：
*   **語法面**：
    *   **定義方式**：C# 使用 `this` 關鍵字加上中括號 `public int this[int index]` 來定義；Swift 使用專屬關鍵字 `subscript`，寫法更像函式定義 `subscript(index: Int) -> Int`。
    *   **參數名稱**：C# 的索引子參數名稱可以在內部使用；Swift 的參數名稱既是用於內部邏輯，也可以像函式參數一樣擁有外部標籤 (Argument Labels)，雖然預設情況下呼叫時不寫標籤。
*   **行為面**：
    *   兩者在定義 `get` 和 `set` 的邏輯上非常相似。Swift 的 `set` 預設有一個 `newValue` 參數，這點與 C# 的 `value` 關鍵字完全一致。

---

## 下標用法與 Dictionary (Subscript Usage)

### 1. 核心觀念
* **概念解說**：
  下標的具體意義取決於上下文。最常見的用途是作為集合 (Collection) 的捷徑。你可以根據業務邏輯自由實作下標。Swift 的 `Dictionary` 就是透過下標來設定與讀取鍵值對 (Key-Value pairs)。
* **關鍵語法**：
  `Dictionary`, `Optional`, `nil`

### 2. 範例解析
**文件原始碼**：
```swift
var numberOfLegs = ["spider": 8, "ant": 6, "cat": 4]
numberOfLegs["bird"] = 2
```

**邏輯解說**：
這段程式碼展示了字典的下標用法。
1. `numberOfLegs` 是一個 `[String: Int]` 型別的字典。
2. 透過 `numberOfLegs["bird"] = 2`，我們使用下標語法新增了一組鍵值對。

> **Note**
> Swift 的 Dictionary 型別實作的下標，其回傳值是 **Optional** 型別 (例如 `Int?`)。這是因為字典中可能不存在你查詢的 Key。Swift 的 Dictionary 下標在 set 時接受的是 **Optional**，因此能透過指派 `nil` 來表達「移除元素」的語意。

### 3. C# 開發者視角

**概念對應**：
這對應到 C# `Dictionary<TKey, TValue>` 的索引子操作，但在處理「Key 不存在」的情況時，行為有巨大的差異。

**C# 對照程式碼**：
```csharp
var numberOfLegs = new Dictionary<string, int>
{
    { "spider", 8 },
    { "ant", 6 },
    { "cat", 4 }
};

numberOfLegs["bird"] = 2; // 設定或新增值，語法相同

// 但讀取時行為不同：
// int legs = numberOfLegs["dragon"]; // C# 會拋出 KeyNotFoundException
```

**關鍵差異分析**：
*   **行為面 (極重要)**：
    *   **Swift**：`dictionary[key]` 回傳的是 **Optional** (例如 `Int?`)。如果 Key 不存在，它回傳 `nil`，不會崩潰。這強迫開發者處理值可能為空的情況。
    *   **C#**：`dictionary[key]` 在讀取時，如果 Key 不存在，會直接拋出 `KeyNotFoundException`。C# 開發者通常需要先用 `ContainsKey` 或 `TryGetValue` 來防禦。
*   **刪除元素**：Swift 可以透過 `dict[key] = nil` 來刪除元素；C# 必須呼叫 `dict.Remove(key)`，將值設為 `null` (若是 Reference type) 並不會移除該 Key。

---

## 下標選項與多參數 (Subscript Options)

### 1. 核心觀念
* **概念解說**：
  下標可以接受任意數量的參數，參數也可以是任意型別。這被稱為**下標多參數 (subscript overloading)**。這在處理多維度資料結構（如矩陣）時非常有用。
* **關鍵語法**：
  `assert`, `Multiple Parameters`
* **官方提示**：
  下標可以使用可變參數 (Variadic Parameters) 和預設參數值，但**不能**使用 `in-out` 參數。

### 2. 範例解析
**文件原始碼**：
```swift
struct Matrix {
    let rows: Int, columns: Int
    var grid: [Double]
    init(rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
        grid = Array(repeating: 0.0, count: rows * columns)
    }
    func indexIsValid(row: Int, column: Int) -> Bool {
        return row >= 0 && row < rows && column >= 0 && column < columns
    }
    subscript(row: Int, column: Int) -> Double {
        get {
            assert(indexIsValid(row: row, column: column), "Index out of range")
            return grid[(row * columns) + column]
        }
        set {
            assert(indexIsValid(row: row, column: column), "Index out of range")
            grid[(row * columns) + column] = newValue
        }
    }
}

var matrix = Matrix(rows: 2, columns: 2)
matrix[0, 1] = 1.5
matrix[1, 0] = 3.2
```

**邏輯解說**：
1. `Matrix` 結構將二維矩陣扁平化儲存在一維陣列 `grid` 中。
2. 定義了接受兩個參數的下標 `subscript(row: Int, column: Int)`。
3. `get` 與 `set` 中使用 `assert` 來確保索引不越界。
4. 使用時，參數用逗號分隔：`matrix[0, 1]`。

### 3. C# 開發者視角

**概念對應**：
C# 的索引子同樣支援多個參數，經常用於處理多維陣列或類似矩陣的結構。

**C# 對照程式碼**：
```csharp
public struct Matrix
{
    private readonly int _rows;
    private readonly int _columns;
    private double[] _grid;

    public Matrix(int rows, int columns)
    {
        _rows = rows;
        _columns = columns;
        _grid = new double[rows * columns];
    }

    public double this[int row, int col]
    {
        get
        {
            // 簡化的邊界檢查
            return _grid[(row * _columns) + col];
        }
        set
        {
            _grid[(row * _columns) + col] = value;
        }
    }
}

var matrix = new Matrix(2, 2);
matrix[0, 1] = 1.5; // C# 語法完全相同
```

**關鍵差異分析**：
*   **語法面**：在呼叫端，Swift 的 `matrix[0, 1]` 與 C# 的 `matrix[0, 1]` 寫法完全一致。
*   **參數限制**：Swift 明確禁止 `in-out` 參數用於下標，這與 C# 索引子不能使用 `ref` 或 `out` 參數的限制類似。

---

## 型別下標 (Type Subscripts)

### 1. 核心觀念
* **概念解說**：
  前面介紹的都是「實體下標 (Instance Subscripts)」，也就是必須先建立物件實體才能使用。Swift 進一步支援 **型別下標 (Type Subscripts)**，這是屬於「型別本身」的下標，直接透過型別名稱呼叫。
* **關鍵語法**：
  `static subscript`, `class subscript` (用於類別繼承)

### 2. 範例解析
**文件原始碼**：
```swift
enum Planet: Int {
    case mercury = 1, venus, earth, mars, jupiter, saturn, uranus, neptune
    static subscript(n: Int) -> Planet {
        return Planet(rawValue: n)!
    }
}
let mars = Planet[4]
print(mars)
```

**邏輯解說**：
1. 在 `Planet` 列舉中，使用 `static subscript` 定義了一個型別下標。
2. 呼叫時，不需要實例化 `Planet`，直接使用型別名稱：`Planet[4]`。
3. 這裡利用 `rawValue` 初始化並強制解包 (`!`) 來回傳對應的星球。

### 3. C# 開發者視角

**概念對應**：
這是 C# 目前**不具備**的功能。

**關鍵差異分析**：
*   **語法面**：C# 不支援 `static this[...]` 這種語法。你無法在 C# 中寫 `ClassName[index]`。
*   **替代方案**：在 C# 中，若要達成類似效果，通常會使用靜態方法 (Static Method) 或靜態唯讀集合。
    ```csharp
    // C# 替代寫法
    public enum Planet { Mercury = 1, Venus, Earth, Mars, ... }

    public static class PlanetExtensions {
        public static Planet Get(int n) {
            return (Planet)n;
        }
    }

    // 呼叫
    var mars = PlanetExtensions.Get(4);
    ```
*   **行為面**：Swift 的 Type Subscripts 讓語法更具一致性，將「透過索引存取」的概念延伸到了型別層級，這是 C# 開發者在轉換時會覺得較為新奇且方便的特性。