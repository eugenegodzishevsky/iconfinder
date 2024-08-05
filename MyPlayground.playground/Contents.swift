import UIKit

//**ЗАДАНИЕ 1**
//
//**Условия задачи:**
//На вход подается матрица A x B (1 <= A, B <= 10^3; 1 <= A * B <= 10^3). Значение каждой ячейки - целое число 0 или 1. Найти наименьшее расстояние от каждой ячейки до ближайшей ячейки со значением 1. Расстояние между соседними ячейками равно 1.
//
//**Пример:**
//Входная матрица:
//[[1,0,1],
//[0,1,0],
//[0,0,0]]
//Выходная матрица:
//[[0,1,0],
//[1,0,1],
//[2,1,2]]

func updateMatrix(_ matrix: [[Int]]) -> [[Int]] {
    let m = matrix.count
    let n = matrix[0].count
    
    // Инициализируем матрицу расстояний с большим значением (например, Int.max)
    var distance = Array(repeating: Array(repeating: Int.max, count: n), count: m)
    
    // Первый проход: слева направо, сверху вниз
    for i in 0..<m {
        for j in 0..<n {
            if matrix[i][j] == 1 {
                distance[i][j] = 0
            } else {
                // Обновляем расстояние до ближайшего 1
                if i > 0 {
                    distance[i][j] = min(distance[i][j], distance[i-1][j] + 1)
                }
                if j > 0 {
                    distance[i][j] = min(distance[i][j], distance[i][j-1] + 1)
                }
            }
        }
    }
    
    // Второй проход: справа налево, снизу вверх
    for i in stride(from: m-1, through: 0, by: -1) {
        for j in stride(from: n-1, through: 0, by: -1) {
            if i < m-1 {
                distance[i][j] = min(distance[i][j], distance[i+1][j] + 1)
            }
            if j < n-1 {
                distance[i][j] = min(distance[i][j], distance[i][j+1] + 1)
            }
        }
    }
    
    return distance
}

// Пример использования
print(updateMatrix([[1, 0, 1],
                    [0, 1, 0],
                    [0, 0, 0]]))

