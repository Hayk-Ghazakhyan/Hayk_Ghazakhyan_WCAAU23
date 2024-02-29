PASSING_GRADE = 8


class Trainee:
    def __init__(self, name, surname):
        self.name = name
        self.surname = surname
        self.done_home_tasks = 0
        self.visited_lectures = 0
        self.missed_lectures = self.visited_lectures
        self.missed_home_tasks = self.done_home_tasks
        self.mark = 0

    def visit_lecture(self):
        self.visited_lectures += 1
        self._add_points(1)

    def do_homework(self):
        self.done_home_tasks += 2
        self._add_points(2)

    def miss_lecture(self):
        self.missed_lectures -= 1
        self._subtract_points(1)

    def miss_homework(self):
        self.missed_home_tasks -= 2
        self._subtract_points(2)

    def _add_points(self, points: int):
        if self.mark + points <= 10:
            self.mark += points
        else:
            self.mark = 10

    def _subtract_points(self, points):
        self.mark -= points
        if self.mark < 0:
            self.mark = 0

    def is_passed(self):
        if self.mark >= 8:
            print("Good job!")
        else:
            print(f"You need to {8 - self.mark} points. Try to do your best!")

    def __str__(self):
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
obj.do_homework()
obj._add_points(6)
obj.miss_lecture()
obj.miss_lecture()
print(obj.is_passed())
