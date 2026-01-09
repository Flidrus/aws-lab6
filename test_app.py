import unittest

from functions import get_an


class ProgressionCalculatorTest(unittest.TestCase):

    def test_get_an(self):

        self.assertEqual(get_an(1, 1, 3), 3)
        self.assertEqual(get_an(2, 0, 5), 2)
        self.assertEqual(get_an(5, 2, 3), 9)
        self.assertEqual(get_an(1, -3, 4), -8)


if __name__ == '__main__':
    unittest.main()
