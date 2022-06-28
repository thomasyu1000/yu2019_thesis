# Code for Yu, Thomas (2019), "A Model of Countercyclical Macroprudential Policy"

Undergraduate honors thesis at the University of Chicago. [Link to paper](https://thomas-yu.com/files/YuThomas_HonorsThesis.pdf).

This code develops a quantitative DSGE model featuring a social cost of debt, which can be addressed with either a debt tax or a capital requirement on financial intermediaries that responds countercyclically to aggregate debt and output. 
IRFs are plotted to observe the economy's response to a productivity shock and capital quality shock. 
Finally, a welfare analysis is used to determine the optimal debt tax rate and compare welfare between the baseline model, optimal debt tax model, and some variants of the capital requirement model.

To build this project, I referenced sample code from Gertler and Karadi (2011), available on [Peter Karadi's personal website](https://sites.google.com/site/pkaradi696/research) 
(direct link to reference code [here](https://sites.google.com/site/pkaradi696/contact-and-cv/files/GK.zip)).

## Quick guide
1. Ensure that [MATLAB](https://www.mathworks.com/products/matlab.html) and [Dynare](https://www.dynare.org/resources/quick_start/) are installed and set up.
2. Clone or download the contents of this repo.
3. Run `main.m` to automatically populate the `dynare` folder with generated Dynare code, the `data` folder with simulated time-series data, and the `figures` folder with graphs.
