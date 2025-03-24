# Freight Calculator

### Purpose 
Calculate the best route between two destinations in a given list of sailings.

The criteria include
* cheapest
* cheapest direct
* fastest
* fastest direct

### Usage 
In order to run this locally you will only need docker installed. You can use the provided preconfigured files or create a new one
where you will be passed in the docker image as an environment variable.

The file should have the following format
* The first line is the origin_port code
* The second line is the destination_port code
* The third line is the criteria (cheapest-direct, cheapest, fastest, fastest-direct)

```
CNSHA
NLRTM
cheapest-direct
```

Build the image with 
```
docker build -t freight_calculator .
```

Run the app with 
```
docker run -e INPUT="$(cat config/cheapest.txt)" freight_calculator
```
```
docker run -e INPUT="$(cat config/cheapest_direct.txt)" freight_calculator
```
```
docker run -e INPUT="$(cat config/fastest.txt)" freight_calculator
```
```
docker run -e INPUT="$(cat config/fastest_direct.txt)" freight_calculator
```

### Tests and CI
I have added a github workflow that will run every time new changes are pushed and will execute the tests and upload 
the test coverage to github [pages](https://alexwebgr.github.io/freight_calculator)

There is also a workflow for rubocop and one that will build and run the image with the 4 preconfigured files as a way to 
ensure no runtime exceptions are raised

I am using fixtures to mock different scenarios of inputs where for example the direct is the cheapest or 
where the rates are equal between the direct and indirect or the exchange rate is missing. 

### Assumptions
We assume that the exchange rates are provided by an external service we have no control over.
