local vida = require('vida')

function test(txt, func)
    io.write(txt, ' : ')
    local status, err = pcall(func)
    if status then
        io.write('✓\n')
    else
        io.write('✗\n')
        error(err, 2)
    end
end

test("allow constants", function()
    local fast = vida.source(
        'int testConstant;',
        'int testConstant = 101;'
    )
    assert(fast.testConstant == 101)
end)

test("simple addition", function()
    local fast = vida.source(
        'int add(int, int);',
        'int add(int a, int b) { return a+b; }'
    )
    assert(fast.add(3, 5) == 8)
end)

test("multiple functions and types", function()
    local fast = vida.source([[
        typedef unsigned char uchar;
        int add(int, int);
        uchar mult(uchar, uchar);
    ]],[[
        int add(int a, int b) {
            return a + b;
        }
        uchar mult(uchar x, uchar y) {
            return x * y;
        }
    ]])
    assert(fast.add(1000, 1001) == 2001)
    assert(fast.mult(123, 125) == 15)
end)