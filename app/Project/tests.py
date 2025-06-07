"""
sample tests
"""

from django.test import SimpleTestCase
from Project import calc


class ClacTests(SimpleTestCase):
    """test the calc module"""

    def test_add_numbers(self):  # must start with test
        res = calc.add(5, 6)
        self.assertEqual(res, 11)

    def test_subtract_numbers(self):
        res = calc.subtract(10, 15)
        self.assertEqual(res, 5)
