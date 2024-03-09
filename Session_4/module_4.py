PASSING_GRADE = 8


class Trainee:

    """class Trainee to count total of points of students
    Define initial values 0 and add them some points if any action happens
    Finally, we define 'is_passed' method to determine
    if the student has obtained sufficient grades to pass.
    """

    def __init__(self, name, surname):
        # define instance variables
        self.name = name
        self.surname = surname
        self.done_home_tasks = 0
        self.visited_lectures = 0
        self.missed_lectures = 0
        self.missed_home_tasks = 0
        self.mark = 0

    def visit_lecture(self):
        # add 1 point to visited_lectures
        # call _add_points methode to get final points
        self.visited_lectures += 1
        self._add_points(1)

    def do_homework(self):
        # add 2 point to home tasks
        # call _add_points methode to get final points
        self.done_home_tasks += 2
        self._add_points(2)

    def miss_lecture(self):
        # add 1 point to missed_lectures
        # call _subtract_points methode to get final points
        self.missed_lectures += 1
        self._subtract_points(1)

    def miss_homework(self):
        # add 1 point to missed_home_tasks
        # call _subtract_points methode to get final points
        self.missed_home_tasks += 2
        self._subtract_points(2)

    def _add_points(self, points: int):
        # This method is used to add points to self.mark, and it's also used in other methods
        if self.mark + points <= 10:
            self.mark += points
        else:
            self.mark = 10

    def _subtract_points(self, points):
        # This method is used to subtract points to self.mark, and it's also used in other methods
        self.mark -= points
        if self.mark < 0:
            self.mark = 0

    def is_passed(self):
        # Used to call and get final result whether the student passed or not

        if self.mark >= PASSING_GRADE:
            print("Good job!")
        else:
            print(
                f"You need to {PASSING_GRADE - self.mark} points. Try to do your best!"
            )

    def __str__(self):
        # used to return string in the output
        status = (
            f"Trainee {self.name.title()} {self.surname.title()}:\n"
            f"done homework {self.done_home_tasks} points;\n"
            f"missed homework {self.missed_home_tasks} points;\n"
            f"visited lectures {self.visited_lectures} points;\n"
            f"missed lectures {self.missed_lectures} points;\n"
            f"current mark {self.mark};\n"
        )
        return status


obj = Trainee("Hayk", "Ghazakhyan")
obj.visit_lecture()
print(obj.is_passed())
obj._add_points(6)
print(obj.is_passed())
obj.do_homework()
print(obj.is_passed())
