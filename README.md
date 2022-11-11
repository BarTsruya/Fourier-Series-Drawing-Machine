# Fourier-Series-Drawing-Machine
The computer will draw the user drawing by using Fourier Series coefficients.


Openning Window: Consist of 2 options.
1. Draw - this will let the user creat its own drawing. The user needs to select a position on the screen which is the starting point of the drawing.
   Then the user can choose the following point. Each mouse click is another point of the drawing. It is important to select the dots in an order and that two
   consecutive dots will be next to each other. Even if you want to draw a line, it is neccesary to select a couple of points throw the line so that the computer
   will achive a better prepormance later.
2. Load - this option is for loading a saved draw from the computer memory. The computer will show the drawing as it was saved without letting the user to edit it.

Computer Drawing Window:
After drawing a figure on the screen with the Draw option, or after loading a saved figure from the memory - comes the compuer turn.
On the screen will apear the follow: the user figure in black, and the computer drawing machine with changing color.
The computer drawing machine is actually a sequence of vector acrrows sum up to get closer to the user figure. What features the user have?
1. There is the N parameter which tells us that the computer uses the [-N...-1,0,1...N] discrit frequencies. The user can control the N parameter by two buttons (+ for increase and - for decrease).
   One can look at the k frequency as vector turning k circles in one unit of time. And the negative frequncies just turning in the opposite direction.
   When the drawing system combines all these vectors together, the computer figure can be seen. A bigger N, brings a more accurate computer figure.
   But the user needs to be careful with the scale of N. When N gets really high, it could hurt the accuracy because gibs effect would be shown.
2. Arrows button - detrmines if the computer drawing machine will draw the vectors with arrows shape or just a line.
3. Circles button - determines if the computer drawing machine will draw the circles which the vectors turns around on.


Cool to know:
The fourier series formula consist of exponents like ei^(-n*2*PI*t) when n represents the frequency and t is in range [0,1] and represent the point in the time line (when it reaches to 1 a time unit accomplished).
A complex exponent, while t changes, also can be presented as a circle with a point moves on it. That are the vectors mentioned above.
And where do the fourier coefficients involve? the exponent of the n frequency is multiplied by Cn in the formula. The visual meaning is that the absolut value of Cn is the radius of that circle! 








