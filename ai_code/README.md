Dataset

None (0), Lateral Raises (1), Curls (2), Dumbell Presses (3)

Train/Val/Test: 80/10/10

Each exercise entry is going to describe a motion being done twice. This is to decrease the rate of false triggers while also making so we know how many reps that user already did upon detection (in this case 2).

Once the exercise is dentifies, it should also be able to count reps

It determines that they are done if there is 3 seconds of inaction (no reps or discernable exercise movement)