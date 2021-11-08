import tonos_ts4.ts4 as ts4

eq = ts4.eq

"""
POSITIVE
Should call getOpenedTasks()
@returns uint - number of opened tasks
"""
def test1():
    keypair = ts4.make_keypair()

    t_number = 1

    tut1 = ts4.BaseContract('StorageContract',
         ctor_params = dict(t_number = t_number),
        keypair = keypair
    )

    tut2 = ts4.BaseContract('ClientForStorage',
         ctor_params = dict(t_number = t_number),
        keypair = keypair
    )

    address = tut1.address

    print(address)

    tut2.call_method('store', {'currentStorage': address, 'val' : 5})

    result = tut1.call_getter('storageValue')
    print(result)

    assert eq(5, result)


ts4.init('contracts/', verbose = True)



# Run a test
test1()