import tonos_ts4.ts4 as ts4

eq = ts4.eq

"""
POSITIVE
Should call constructor
"""
def test1():
    keypair = ts4.make_keypair()

    t_number = 1

    tut = ts4.BaseContract('TaskList',
         ctor_params = dict(t_number = t_number),
        keypair = keypair
    )

    assert eq(keypair, tut.keypair)

"""
POSITIVE
Should call addTask(string TaskName)
@params string
"""
def test2():
    keypair = ts4.make_keypair()

    t_number = 1

    tut = ts4.BaseContract('TaskList',
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
    
"""
POSITIVE
Should call getAllTasks()
@returns mapping (uint8 => Task)
struct Task {
    int id;
    string taskName;
    uint32 timestamp;
    bool closed;
}
"""
def test3():
    keypair = ts4.make_keypair()

    t_number = 1

    tut = ts4.BaseContract('TaskList',
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

    tut.call_method('closeTaskById', {'id': 0})
    tut.call_method('closeTaskById', {'id': 5})
    tut.call_method('closeTaskById', {'id': 9})

    assert eq(True, ( tut.call_getter('tasks'))[0]['closed'])
    assert eq(True, ( tut.call_getter('tasks'))[5]['closed'])
    assert eq(True, ( tut.call_getter('tasks'))[9]['closed'])

    result = tut.call_method('getAllTasks', {})

    assert eq(True, result[0]['closed'])
    assert eq(False, result[1]['closed'])
    assert eq(False, result[3]['closed'])
    assert eq(False, result[4]['closed'])
    assert eq(True, result[5]['closed'])
    assert eq(False, result[6]['closed'])
    assert eq(False, result[7]['closed'])
    assert eq(False, result[8]['closed'])
    assert eq(True, result[9]['closed'])

"""
POSITIVE
Should call getTaskNameById()
@params uint id
@returns string name
"""
def test4():
    keypair = ts4.make_keypair()

    t_number = 1

    tut = ts4.BaseContract('TaskList',
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

    result = tut.call_method('getTaskNameById', {'id': 0})

    assert eq('Task1', result)

"""
POSITIVE
Should call deleteTaskById()
@params uint id
"""
def test5():
    keypair = ts4.make_keypair()

    t_number = 1

    tut = ts4.BaseContract('TaskList',
         ctor_params = dict(t_number = t_number),
        keypair = keypair
    )

    i = 0
    while i < 5:
        i += 1
        tut.call_method('addTask', {'taskName': 'Task' + str(i)})

    result = tut.call_getter('tasks')
    i = 0
    while i < 5:
        assert eq('Task' + str(i + 1), result[i]['taskName'])
        i += 1

    assert eq(5, tut.call_getter('sequence'))

    tut.call_method('closeTaskById', {'id': 0})
    tut.call_method('closeTaskById', {'id': 2})
    tut.call_method('closeTaskById', {'id': 4})

    assert eq(True, ( tut.call_getter('tasks'))[0]['closed'])
    assert eq(True, ( tut.call_getter('tasks'))[2]['closed'])
    assert eq(True, ( tut.call_getter('tasks'))[4]['closed'])

    print(tut.call_getter('sequence'))
    tut.call_method('deleteTaskById', {'id':4})
    tut.call_method('deleteTaskById', {'id':3})
    tut.call_method('deleteTaskById', {'id':2})
    tut.call_method('deleteTaskById', {'id':1})
    tut.call_method('deleteTaskById', {'id':0})

    result = tut.call_getter('tasks')
    assert eq({}, result)
    result = tut.call_getter('storeNumbers')
    assert eq([], result)

"""
POSITIVE
Should call closeTaskById()
@params uint8 id
"""
def test6():
    keypair = ts4.make_keypair()

    t_number = 1

    tut = ts4.BaseContract('TaskList',
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

    tut.call_method('closeTaskById', {'id': 0})
    tut.call_method('closeTaskById', {'id': 5})
    tut.call_method('closeTaskById', {'id': 9})

    assert eq(True, ( tut.call_getter('tasks'))[5]['closed'])

"""
POSITIVE
Should call getOpenedTasks()
@returns uint - number of opened tasks
"""
def test7():
    keypair = ts4.make_keypair()

    t_number = 1

    tut = ts4.BaseContract('TaskList',
         ctor_params = dict(t_number = t_number),
        keypair = keypair
    )

    i = 0
    while i < 5:
        i += 1
        tut.call_method('addTask', {'taskName': 'Task' + str(i)})

    result = tut.call_getter('tasks')
    i = 0
    while i < 5:
        assert eq('Task' + str(i + 1), result[i]['taskName'])
        i += 1

    assert eq(5, tut.call_getter('sequence'))

    tut.call_method('closeTaskById', {'id': 0})
    tut.call_method('closeTaskById', {'id': 2})
    tut.call_method('closeTaskById', {'id': 4})

    assert eq(True, ( tut.call_getter('tasks'))[0]['closed'])
    assert eq(True, ( tut.call_getter('tasks'))[2]['closed'])
    assert eq(True, ( tut.call_getter('tasks'))[4]['closed'])

    result = tut.call_method('getOpenedTasks', {})

    assert eq(2, result)

ts4.init('contracts/', verbose = True)



# Run a test
#test1()
#test2()
#test3()
#test4()
test5()
#test6()
#test7()