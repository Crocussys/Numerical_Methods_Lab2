function usage()
    mprintf("Lab2 [path_a] [path_b]\n\n")
    mprintf("path_a - Файл коэфициентов\n")
    mprintf("path_b - Файл свободных членов\n")
endfunction

function ValueError()
    mprintf("Error 3: Invalid value\n")
    return -3
endfunction

function [txt, err]=txt_in_file(file_name)
    [fl, err] = mopen(file_name, 'r')
    if err ~= 0 then
        mprintf("Error 2: File opening error\n")
        return
    end
    txt = mgetl(fl)
    mclose(fl)
endfunction

argv = sciargs()
[m, argc] = size(argv)
if argc >= 3 then
    if argv(3) == "-h" then
        usage()
        return 0
    end
end
if argc < 4 then
    usage()
    mprintf("\nError 1: Not enough arguments")
    return -1
end

len = 0
a= []
b= []
txt = []
[txt, err] = txt_in_file(argv(3))
if err ~= 0 then
    return -2
end
[n, m] = size(txt)
for i = 1:n do
    elems = strsplit(txt(i), " ")
    [count_elems, m] = size(elems)
    if len == 0 then
        len = count_elems
    end
    if count_elems ~= len then
        return ValueError()
    end
    line = strtod(elems)
    for j = 1:count_elems do
        if line(j) == %nan then
            return ValueError()
        else
            a(i, j) = line(j)
        end
    end
end
[txt, err] = txt_in_file(argv(4))
if err ~= 0 then
    return -2
end
count_elems = 0
[n, m] = size(txt)
for i = 1:n do
    elems = strsplit(txt(i), " ")
    [count, m] = size(elems)
    count_elems = count_elems + count
    digits = strtod(elems)
    for j = 1:count do
        if digits(j) == %nan then
            return ValueError()
        end
        b($+1) = digits(j)
    end
end
if count_elems ~= len then
    return ValueError()
end

for i = 1:len do
    if a(i, i) == 0 then
        flag = %t
        for k = i+1:len do
            if a(k, i) ~= 0 then
                temp_arr = []
                for j = 1:len do
                    temp_arr(j) = a(i, j)
                end
                for j = 1:len do
                    a(i, j) = a(k, j)
                end
                for j = 1:len do
                    a(k, j) = temp_arr(j)
                end
                temp = b(i)
                b(i) = b(k)
                b(k) = temp
                flag = %f
                break
            end
        end
        if flag then
            mprintf("Cистема не имеет единственного решения")
            return 0
        end
    end
    value = a(i, i)
    for k = i:len do
        a(i, k) = a(i, k) / value
    end
    b(i) = b(i) / value
    for j = i+1:len do
        value = a(j, i)
        for k = 1:len do
            a(j, k) = a(j, k) - value * a(i, k)
        end
        b(j) = b(j) - value * b(i)
    end
end

answer = []
for i = len:-1:1 do
    answer(i) = b(i)
    for j = i+1:len do
        answer(i) = answer(i) - a(i, j) * answer(j)
    end
end

for i = 1:len do
    mprintf("x%d = %f\n", i, answer(i))
end

return 0
