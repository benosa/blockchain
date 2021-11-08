import tonos_ts4.ts4 as ts4

eq = ts4.eq

def test1():
    keypair = ts4.make_keypair()

    t_number = 1

    tut = ts4.BaseContract('MyMap',
         ctor_params = dict(t_number = t_number),
        keypair = keypair
    )

    i = 0
    while i < 10:
        i += 1
        tut.call_method('addTask', {'taskName': 'Task' + str(i)})

    result = tut.call_getter('tasks')
    i = 0
    while i < 10:
        assert eq('Task' + str(i + 1), result[i]['taskName'])
        i += 1

    assert eq(10, tut.call_getter('sequence'))

    tut.call_method('iterate', {})

ts4.init('contracts/', verbose = True)



# Run a test
test1()
