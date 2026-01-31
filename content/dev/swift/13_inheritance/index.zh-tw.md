---
title : "[從C#到Swift] 13. Inheritance"
date : 2026-01-31T14:00:00+08:00
tags : ["Swift", "C#"]
categories : ["From C# to Swift"]
description : "深入解析 Swift 的繼承機制，包含基礎類別定義、方法覆寫規則以及屬性觀察器的繼承應用。本文特別針對 C# 開發者，比較 Swift `override` 關鍵字的強制性、屬性覆寫的靈活度，以及 `final` 與 `sealed` 的語法對照，助你快速掌握 Swift 物件導向特性。"
keywords : ["Swift vs C#", "iOS Development", "Inheritance", "Override", "Final Class", "Property Observers"]
featureImage : "cover.jpg"
featureImageDescription : "Swift 類別繼承與覆寫機制概念圖"
slug : "from-csharp-to-swift/inheritance"
---

![](cover.jpg)


**從 C# 視角學習 Swift**  <br>
> [Swift : Inheritance](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/inheritance)


## 繼承基礎與基礎類別 (Base Class)

### 1. 核心觀念
*   **概念解說**：繼承是物件導向程式設計的基石。在 Swift 中，類別 (Class) 可以繼承另一個類別的方法、屬性與其他特性。Swift 與 C# 最大的不同在於，Swift 的類別並沒有一個萬用的「根類別」（如 C# 的 `System.Object`）。如果你定義一個類別且沒有指定繼承對象，它自動就會成為一個「基礎類別 (Base Class)」。
*   **關鍵語法**：`class ClassName`, `subclassing`
*   **官方提示**：
> Swift 的類別不會繼承自一個通用的基礎類別。如果你定義類別時未指定超類別 (Superclass)，該類別自動成為基底類別。

### 2. 範例解析
**文件原始碼**：
```swift
class Vehicle {
    var currentSpeed = 0.0
    var description: String {
        return "traveling at \(currentSpeed) miles per hour"
    }
    func makeNoise() {
        // do nothing - an arbitrary vehicle doesn't necessarily make a noise
    }
}

let someVehicle = Vehicle()
print("Vehicle: \(someVehicle.description)")
// Vehicle: traveling at 0.0 miles per hour
```

**邏輯解說**：
這段程式碼定義了一個名為 `Vehicle` 的基礎類別。它擁有一個儲存屬性 `currentSpeed`，一個唯讀的計算屬性 `description`，以及一個方法 `makeNoise`。這展示了 Swift 類別定義的基本結構。

### 3. C# 開發者視角

**概念對應**：C# 的 Class 定義。

**C# 對照程式碼**：
```csharp
public class Vehicle {
    // 為了讓子類別能覆寫，建議使用虛擬屬性而非欄位
    public virtual double CurrentSpeed { get; set; } = 0.0;
    
    // C# 的唯讀屬性寫法，需標記 virtual 才能被覆寫
    public virtual string Description => $"traveling at {CurrentSpeed} miles per hour";
    
    // C# 需要顯式標記 virtual 才能被覆寫 (若設計為可被繼承修改)
    public virtual void MakeNoise() {
        // do nothing
    }
}
```

**關鍵差異分析**：
*   **語法面**：Swift 的 `class` 定義非常簡潔，不需要像 C# 一樣預設加上 `public`（Swift 預設為 `internal`）。
*   **行為面**：**這是重點！** 在 C# 中，若要讓方法能被覆寫，必須在父類別顯式加上 `virtual` 關鍵字。但在 Swift 中，類別的方法預設就可以被子類別覆寫（除非加上 `final`），開發者不需要在父類別寫 `virtual`。

---

## 子類別化 (Subclassing)

### 1. 核心觀念
*   **概念解說**：子類別化是基於現有類別建立新類別的行為。子類別會繼承父類別的所有特性，並且可以添加新的屬性或方法。
*   **關鍵語法**：`class Subclass: Superclass`

### 2. 範例解析
**文件原始碼**：
```swift
class Bicycle: Vehicle {
    var hasBasket = false
}

let bicycle = Bicycle()
bicycle.hasBasket = true
bicycle.currentSpeed = 15.0
print("Bicycle: \(bicycle.description)")
// Bicycle: traveling at 15.0 miles per hour

class Tandem: Bicycle {
    var currentNumberOfPassengers = 0
}

let tandem = Tandem()
tandem.hasBasket = true
tandem.currentNumberOfPassengers = 2
tandem.currentSpeed = 22.0
print("Tandem: \(tandem.description)")
// Tandem: traveling at 22.0 miles per hour
```

**邏輯解說**：
`Bicycle` 繼承自 `Vehicle` 並新增了 `hasBasket` 屬性。`Tandem` 又繼承自 `Bicycle`，形成了繼承鏈。子類別可以自由存取並修改繼承來的屬性（如 `currentSpeed`）。

### 3. C# 開發者視角

**概念對應**：C# 的繼承語法完全一致。

**C# 對照程式碼**：
```csharp
public class Bicycle : Vehicle {
    public bool HasBasket = false;
}
// 使用方式與 Swift 幾乎相同
```

**關鍵差異分析**：
*   **語法面**：兩者都使用冒號 `:` 來表示繼承，結構相同。
*   **行為面**：繼承鏈的邏輯與 C# 完全一致。

---

## 覆寫方法 (Overriding Methods)

### 1. 核心觀念
*   **概念解說**：子類別可以提供自己的實作來取代父類別的行為。Swift 強制要求使用 `override` 關鍵字，這能避免意外覆寫或名稱拼寫錯誤。
*   **關鍵語法**：`override func`

### 2. 範例解析
**文件原始碼**：
```swift
class Train: Vehicle {
    override func makeNoise() {        
        print("Choo Choo")
    }
}

let train = Train()
train.makeNoise()
// Prints "Choo Choo"
```

**邏輯解說**：
`Train` 類別覆寫了 `Vehicle` 的 `makeNoise` 方法。Swift 編譯器會檢查 `Vehicle` 中是否真的存在 `makeNoise`，若不存在或是簽章不符，編譯會報錯。

### 3. C# 開發者視角

**概念對應**：C# 的 `override` 關鍵字。

**C# 對照程式碼**：
```csharp
public class Train : Vehicle {
    // 必須確認父類別有標示 virtual 
    public override void MakeNoise() {
        Console.WriteLine("Choo Choo");
    }
}
```

**關鍵差異分析**：
*   **行為面**：
    *   **C#**：Opt-in 模式。父類別必須說「我可以被覆寫 (`virtual`)」，子類別才能 `override`。
    *   **Swift**：Opt-out 模式。父類別方法預設就是可覆寫的，除非父類別標示為 `final`。
    *   **安全性**：Swift 的 `override` 是強制性的。如果你不小心寫了一個跟父類別同名的方法但沒加 `override`，Swift 會報錯；反之，如果你加了 `override` 但父類別沒這個方法，也會報錯。這點比 C# 的 `new` 關鍵字隱藏行為更為嚴謹且直覺。

---

## 存取父類別成員 (Accessing Superclass Members)

### 1. 核心觀念
*   **概念解說**：當你在子類別中覆寫方法、屬性或下標 (Subscript) 時，經常需要使用父類別既有的實作作為基礎。例如，你可能想在現有的行為之上進行改良，或是將修改後的值存回繼承來的變數中。這時，你需要透過 `super` 前綴來存取父類別的版本。
*   **關鍵語法**：`super`
*   **使用規則**：
    *   **方法 (Methods)**：在覆寫的方法實作中，使用 `super.someMethod()` 來呼叫父類別的版本。
    *   **屬性 (Properties)**：在覆寫的 Getter 或 Setter 實作中，使用 `super.someProperty` 來存取父類別的屬性值。
    *   **下標 (Subscripts)**：在覆寫的下標實作中，使用 `super[someIndex]` 來存取父類別的下標邏輯。

### 2. 範例解析

**語法示意**：
```swift
class Base {
    func doSomething() { print("Base working") }
}

class Sub: Base {
    override func doSomething() {
        super.doSomething() // 1. 先執行父類別原本的工作
        print("Sub working") // 2. 再執行子類別額外的工作
    }
}
```

**邏輯解說**：
 `super` 通常用於 "擴充" 而非 "完全取代" 父類別行為。

### 3. C# 開發者視角

**概念對應**：C# 的 base 關鍵字。

**C# 對照程式碼**：
```csharp
public class Base {
    public virtual void DoSomething() { /*...*/ }
}

public class Sub : Base {
    public override void DoSomething() {
        base.DoSomething(); // C# 使用 base 來呼叫父類別
        // ...
    }
}
```

**關鍵差異分析**：
* **關鍵字**：Swift 使用 super，C# 使用 base


## 覆寫屬性 (Overriding Properties)

### 1. 核心觀念
*   **概念解說**：Swift 允許你覆寫繼承來的屬性（無論是儲存屬性還是計算屬性），以提供自定義的 Getter/Setter，或是添加屬性觀察器。
*   **關鍵語法**：`override var`, `getter`, `setter`
*   **官方提示**：
> 如果你在覆寫屬性時提供了 Setter，那你也必須提供 Getter。如果你不想修改 Getter 的邏輯，可以直接回傳 `super.someProperty`。

### 2. 範例解析
**文件原始碼**：
```swift
class Car: Vehicle {
    var gear = 1
    override var description: String {
        return super.description + " in gear \(gear)"
    }
}

let car = Car()
car.currentSpeed = 25.0
car.gear = 3
print("Car: \(car.description)")
// Car: traveling at 25.0 miles per hour in gear 3
```

**邏輯解說**：
`Car` 覆寫了 `Vehicle` 的 `description` 屬性。透過 `super.description` 取得父類別的文字，再串接上檔位資訊。

### 3. C# 開發者視角

**概念對應**：C# 的屬性覆寫。

**C# 對照程式碼**：
```csharp
public class Car : Vehicle {
    public int Gear = 1;
    // 需確認父類別 Description 標示為 virtual
    public override string Description {
        get { return base.Description + $" in gear {Gear}"; }
    }
}
```

**關鍵差異分析**：
*   **語法面**：Swift 不區分「屬性是欄位 (Field) 還是屬性 (Property)」，在覆寫時統一視為屬性。
*   **行為面**：
    *   **擴展性**：Swift 允許將繼承來的「唯讀」屬性覆寫為「讀寫」屬性（提供 Getter 和 Setter）。但**不能**將「讀寫」屬性覆寫為「唯讀」。
    *   **實作細節**：在 C# 中，通常無法直接 `override` 一個簡單的 Field (變數)，必須是 Property。但在 Swift 中，父類別的 `var currentSpeed = 0.0` (Stored Property) 可以被子類別視為計算屬性來覆寫或添加觀察器，這提供了極大的靈活性。

---

## 覆寫屬性觀察器 (Overriding Property Observers)

### 1. 核心觀念
*   **概念解說**：這是 Swift 獨有且強大的功能。你可以在子類別中，為繼承來的屬性添加 `willSet` 或 `didSet` 觀察器，以便在屬性值改變時收到通知。
*   **關鍵語法**：`didSet`, `willSet`
*   **官方提示**：
> 你不能為繼承來的「常數儲存屬性 (let)」或「唯讀計算屬性」添加觀察器，因為它們的值無法被設定。另外，如果你已經覆寫了 Setter，就不能再添加觀察器（應該直接在 Setter 裡寫邏輯）。

### 2. 範例解析
**文件原始碼**：
```swift
class AutomaticCar: Car {
    override var currentSpeed: Double {
        didSet {
            gear = Int(currentSpeed / 10.0) + 1
        }
    }
}

let automatic = AutomaticCar()
automatic.currentSpeed = 35.0
print("AutomaticCar: \(automatic.description)")
// AutomaticCar: traveling at 35.0 miles per hour in gear 4
```

**邏輯解說**：
`AutomaticCar` 繼承自 `Car`。當 `currentSpeed` 被修改時，`didSet` 會自動觸發並計算適合的檔位 (`gear`)。這完全不需要去修改父類別的程式碼。

### 3. C# 開發者視角

**概念對應**：C# 無直接對應語法，通常透過覆寫 Setter 實作。

**C# 對照程式碼**：
```csharp
public class AutomaticCar : Car {
    // C# 必須覆寫整個屬性來達到類似效果
    public override double CurrentSpeed {
        get { return base.CurrentSpeed; }
        set {
            base.CurrentSpeed = value;
            // 這裡模擬 didSet 的行為
            Gear = (int)(value / 10.0) + 1;
        }
    }
}
```

**關鍵差異分析**：
*   **語法面**：Swift 的 `didSet` 語法非常乾淨，分離了「儲存邏輯」與「觀察邏輯」。
*   **行為面**：在 C# 中，為了達成副作用 (Side Effect)，你必須重寫整個 Setter 並記得呼叫 `base.Property = value`。Swift 讓開發者只需專注於「變更後要做什麼」，降低了出錯（例如忘記賦值）的風險。

---

## 防止覆寫 (Preventing Overrides)

### 1. 核心觀念
*   **概念解說**：如果你希望某個類別、方法或屬性不被繼承或覆寫，可以使用 `final` 關鍵字。
*   **關鍵語法**：`final class`, `final var`, `final func`

### 2. 範例解析
```swift
final class ImmutableVehicle {
    final func makeNoise() {
        print("No override allowed")
    }
}
```

**邏輯解說**：
加上 `final` 後，任何試圖覆寫該成員或繼承該類別的行為，都會導致編譯錯誤。這有助於封裝設計，有時也能帶來編譯器的效能優化（因為不需要動態派發）。

### 3. C# 開發者視角

**概念對應**：C# 的 `sealed` 關鍵字。

**C# 對照程式碼**：
```csharp
// 1. 防止類別被繼承 (對應 final class)
public sealed class FinalVehicle { }

// 2. 防止方法被覆寫 (對應 final func)
public class Train : Vehicle {
    // 在 C# 中，你自己新定義的方法預設就是不可覆寫的 (非 virtual)。
    // 但若是繼承自父類別的 virtual 方法，需使用 sealed override 來禁止後續子類別再覆寫它。
    public sealed override void MakeNoise() {
        Console.WriteLine("Choo Choo");
    }
}
```

**關鍵差異分析**：
*   **語法面**：Swift 使用 `final`，C# 使用 `sealed`。
*   **行為面**：意義完全相同。
    *   `final class` = `sealed class` (不能有子類別)。
    *   `final func` = `sealed override` (在方法已是 override 的情況下) 或是非 virtual 方法 (在 C# 中預設即是)。    