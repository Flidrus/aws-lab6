import unittest

from functions import get_an


class ProgressionCalculatorTest(unittest.TestCase):

    def test_get_an(self):

        self.assertEqual(0, get_an(0))
        self.assertEqual(1, get_an(1))
        self.assertEqual(1, get_an(2))
        self.assertEqual(2, get_an(3))
        self.assertEqual(3, get_an(4))
        self.assertEqual(5, get_an(5))
        self.assertEqual(8, get_an(6))
        self.assertEqual(13, get_an(7))
        self.assertEqual(55, get_an(10))

        with self.assertRaises(ValueError):
            get_an(-1)

if __name__ == '__main__':
    unittest.main()
