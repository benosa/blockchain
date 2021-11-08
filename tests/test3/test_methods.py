import tonos_ts4.ts4 as ts4

eq = ts4.eq

"""
POSITIVE
Should call constructor
"""
def test1():
    keypair = ts4.make_keypair()

    t_number = 1

    tut = ts4.BaseContract('MultiplyAcc',
        ctor_params = dict(t_number = t_number),
        keypair = keypair
    )

    assert eq(keypair, tut.keypair)

    assert eq(t_number, tut.call_getter('accumulator'))

"""
NEGATIVE
Should throw an exception when 
call constructor wiyhout keys
"""
def test2():
    t_number = 1
    try:
        ts4.BaseContract('MultiplyAcc',
            ctor_params = dict(t_number = t_number)
        )
    except RuntimeError as ValueError :
        if( ValueError.args[0].find('101') == -1):
            raise AssertionError('Keypair not set')

"""
POSITIVE
Should call mul method with int param in range >= 1 and <= 10
"""
def test3():
    keypair = ts4.make_keypair()

    t_number = 1

    tut = ts4.BaseContract('MultiplyAcc',
        ctor_params = dict(t_number = t_number),
        keypair = keypair
    )

    t_number = 2

    result = tut.call_method('mul', {'value': t_number})

    assert eq(t_number, result)

    assert eq(t_number, tut.call_getter('accumulator'))

"""
NEGATIVE
Should throw an exception when 
call mul method with int param < 1
"""
def test4():
    keypair = ts4.make_keypair()

    t_number = 1

    tut = ts4.BaseContract('MultiplyAcc',
        ctor_params = dict(t_number = t_number),
        keypair = keypair
    )

    t_number = 0

    result = tut.call_method('mul', {'value': t_number}, None, 103)

    assert eq(None, result)

    assert eq(1, tut.call_getter('accumulator'))

"""
NEGATIVE
Should throw an exception when 
call mul method with int param > 10
"""
def test5():
    keypair = ts4.make_keypair()

    t_number = 1

    tut = ts4.BaseContract('MultiplyAcc',
        ctor_params = dict(t_number = t_number),
        keypair = keypair
    )

    t_number = 11

    result = tut.call_method('mul', {'value': t_number}, None, 104)

    assert eq(None, result)

    assert eq(1, tut.call_getter('accumulator'))

"""
POSITIVE
Should throw an exception when 
call mul method with int param > 10
"""
def test6():
    keypair = ts4.make_keypair()

    t_number = 1

    tut = ts4.BaseContract('MultiplyAcc',
        ctor_params = dict(t_number = t_number),
        keypair = keypair
    )

    t_number = 2

    result = tut.call_method('renderAccumulator', {})

    assert eq(str(1), result)

    assert eq(1, tut.call_getter('accumulator'))

ts4.init('contracts/', verbose = True)



# Run a test
test1()
test2()
test3()
test4()
test5()
test6()