from hello import add
from hello import subtract

def test_add():
    assert add(6, 3) == 9

def test_subtract():
    assert subtract(6, 3) == 3