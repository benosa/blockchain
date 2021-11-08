import tonos_ts4.ts4 as ts4

eq = ts4.eq

"""
POSITIVE
Should call constructor
"""
def test1():
    keypair = ts4.make_keypair()

    t_number = 1

    tut = ts4.BaseContract('StoreQueue',
         ctor_params = dict(t_number = t_number),
        keypair = keypair
    )

    assert eq(keypair, tut.keypair)


"""
POSITIVE
Should call pushToQueue method with string param
"""
def test2():
    keypair = ts4.make_keypair()
    
    t_number = 1
    
    tut = ts4.BaseContract('StoreQueue',
        ctor_params = dict(t_number = t_number),
        keypair = keypair
    )

    str1 = "Ivanov"
    str2 = "Petrov"
    str3 = "Sidorov"

    tut.call_method('pushToQueue', {'value': str1})
    tut.call_method('pushToQueue', {'value': str2})
    tut.call_method('pushToQueue', {'value': str3})

    result = tut.call_getter('storeQueue')

    if((len(result) != 3) or (str1 not in result or str2 not in result or str3 not in result)):
         raise AssertionError('Push method general error')

"""
POSITIVE
Should call getFromQueue method. Method is get and remove first element from array
"""
def test3():
    keypair = ts4.make_keypair()
    
    t_number = 1
    
    tut = ts4.BaseContract('StoreQueue',
        ctor_params = dict(t_number = t_number),
        keypair = keypair
    )

    str1 = "Ivanov"
    str2 = "Petrov"
    str3 = "Sidorov"

    tut.call_method('pushToQueue', {'value': str1})
    tut.call_method('pushToQueue', {'value': str2})
    tut.call_method('pushToQueue', {'value': str3})

    result = tut.call_getter('storeQueue')

    if((len(result) != 3) or (str1 not in result or str2 not in result or str3 not in result)):
         raise AssertionError('Push method general error')

    assert eq(str1, tut.call_method('getFromQueue'))
    assert eq(2, len(tut.call_getter('storeQueue')))

    assert eq(str2, tut.call_method('getFromQueue'))
    assert eq(1, len(tut.call_getter('storeQueue')))

    assert eq(str3, tut.call_method('getFromQueue'))
    assert eq(0, len(tut.call_getter('storeQueue')))

    tut.call_method('getFromQueue', {}, None, 103)

ts4.init('contracts/', verbose = True)



# Run a test
test1()
test2()
test3()