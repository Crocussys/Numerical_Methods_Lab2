import sys

N_DIGITS = 6


def usage():
    print("Lab2 [path_a] [path_b]\n")
    print("path_a - Файл коэфициентов")
    print("path_b - Файл свободных членов")


def main():
    if len(sys.argv) >= 2:
        if sys.argv[1] == "-h":
            usage()
            return 0
    if len(sys.argv) < 3:
        usage()
        print("\nError 1: Not enough arguments")
        return -1

    size = 0
    a = []
    b = []
    try:
        with open(sys.argv[1], 'r') as file:
            count_lines = 0
            for line in file:
                count_lines += 1
                elems = line.split(" ")
                count_elems = len(elems)
                if size == 0:
                    size = count_elems
                if count_elems != size:
                    raise ValueError
                elems = list(map(float, elems))
                a.append(elems)
            if count_lines != size:
                raise ValueError

        with open(sys.argv[2], 'r') as file:
            count_elems = 0
            for line in file:
                elems = line.split(" ")
                elems = list(map(float, elems))
                count_elems += len(elems)
                for elem in elems:
                    b.append(elem)
            if count_elems != size:
                raise ValueError
    except OSError as e:
        print("Error 2: " + str(e))
        return -2
    except ValueError:
        print("Error 3: Invalid value")
        return -3

    for i in range(size):
        if a[i][i] == 0:
            flag = True
            for k in range(i + 1, size):
                if a[k][i] != 0:
                    a[i], a[k] = a[k], a[i]
                    b[i], b[k] = b[k], b[i]
                    flag = False
                    break
            if flag:
                print("Cистема не имеет единственного решения")
                return 0
        value = a[i][i]
        for k in range(i, size):
            a[i][k] /= value
        b[i] /= value
        for j in range(i + 1, size):
            value = a[j][i]
            for k in range(size):
                a[j][k] -= value * a[i][k]
            b[j] -= value * b[i]

    ans = [0] * size
    for i in range(size - 1, -1, -1):
        ans[i] = b[i]
        for j in range(i + 1, size):
            ans[i] -= a[i][j] * ans[j]

    for i in range(size):
        print(f"x{i + 1} = {round(ans[i], N_DIGITS)}")

    return 0


if __name__ == "__main__":
    main()
