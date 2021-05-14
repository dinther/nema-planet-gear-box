# nema-planet-gear-box
parametric, silent planet gearbox for 3D print

# Introduction
Yes, yet another 3D printable planet gearbox. For my project I needed a gearbox as flat as I could possibly make it and silent. The result is this gearbox that can measure as thinas 8 mm thick depending on torque requirements and D-shaft design on the motor at hand. The gearbox is stackable where subsequent stacks are even thinner than the first one.

Contrairy to the many well intended 3D printable panet gear solutions out there, this gearbox is mathematically correct. What this means is that not all teeth combinations mesh properly. They can be forced to mesh by adjusting various tolerances but the result would be a wobbly and noisy gearbox. You know the ones.

This gearbox is tried, printed, modified, printed again tested over an over for months with a pile of parts to show for it. But the results are worth it as you can see in the linked video.

<img src="/images/path_to_success.jpg" alt="Path to success" width="400"/>
<video width="320" height="240" controls>
  <source src="nema17_quiet_gearbox.mp4" type="video/mp4">
</video>

# Capabilities
This planet gearbox comes in four sizes to match Nema11, Nema14, Nema17, Nema23 and Nema34. It uses 3 planet gears driven by the sun gear in the middle which is attached to the Nema stepper motor. The gearbox can be directly mounted onto the Nema motor face plate and has the same square shape and size as the motor.

All printed tests have been on a 36 teeth annulus, with both sun and planet gears set to 12 teeth. This produces a silent and smooth 1:4 gear ratio.
The following gear ratios have been shown to mesh as well and this applies for any of the above mentioned Nema motors:

Ratio   | Annulus | Sun | Planet | Pitch
--------| ------- | --- | -------| ----- 
2.6     |60       |36   |12      | ?
3.0     |44       |22   |11      | ?
3.15789 |41       |19   |11      | ?
3.3     |42       |18   |12      | ?
3.375   |38       |16   |11      | ?
3.5     |30       |12   | 9      | ?
3.6     |26       |10   | 8      | ?
3.69231 |35       |13   |11      | ?
3.75    |44       |16   |14      | ?
3.8     |42       |15   |13      | ?
4       |27       | 9   | 9      | ?
4       |36       |12   |12      | ?
4       |45       |15   |15      | ?
4.2     |32       |10   |11      | ?
4.25    |39       |12   |13      | ?
4.5     |42       |12   |15      | ?
4.667   |33       | 9   |12      | ?
4.8     |38       |10   |14      | ?
5.4     |44       |10   |17      | ?
6.0     |60       |12   |24      | ?
