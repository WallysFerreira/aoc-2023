# Part 1

There are multiple categories (Seed, Soil, Fertilizer, Water, Light, Temperature, Humidity, Location) and we have a map that describes how to convert one category to the immediate next category.

## Objective
A list of seed numbers is given and the lowest location number is expected (end-to-end).

In the future it may be necessary to do conversions with a later source category and/or an earlier destination category.


## Steps
- Extract seeds and maps from file and store in an object
- Decide how many times to convert based on source and destination categories
- Get destination number for each seed and store in a list
- Return the lowest number in the list

## Steps details

### Deciding how many times to convert
Using a list with the categories names, take the distance between the source and destination category, that will determine how many times to run the algorithm the get the destination number, using the return from the function as the input next time the algorithm is ran.

Something like

```
int getDestination(source, sourceCategory, destCategory) {
    categoriesList = ["seed", "fertilizer", ..., "temperature", "location"]
    distance = categoriesList.find(destCategory) - categoriesList.find(sourceCategory)
    destNumber = source
    
    for (i = 0; i <= distance; i++) {
        destNumber = getDestinationNumber(destNumber)
    }
    
    return destNumber
}
```


### Getting the destination number

Given the source number and the source and destination  ranges return the destination number. Could do it with or without lists

#### Without lists 

Object stores destination range start, source range start and range length.

##### Algorithm

- Check if ***source*** is between ***source range start*** and ***source range start*** plus ***range length*** of any of both lists
    - If so, calculate ***destination range start*** plus ***source*** minus ***source range start***
    - If not, return the source

Something like
```
int getDestinationNumber(source, sourceRangeStart, destRangeStart, rangeLength) {
    if (source > sourceRangeStart &&
        source < sourceRangeStart + rangeLength)
        return destRangeStart + source - sourceRangeStart

    return source
}
```

##### Pros
- Probably faster
- Smaller Object (irrelevant)

##### Cons
- Algorithm is harder to understand

#### With lists

Object stores two lists for each line on the map, one with the numbers on the source range and the other with the numbers on the destination range. 

##### Algorithm
- Check if any of the source range lists contains source.
    - If so, get the element at the same position in the destination range list
    - If not, return the source

Something like
```
int getDestinationNumber(source, sourceList, destinationList) {
    index = sourceList.find(source)
    
    if (index > -1) return destinationList[index]
    
    return source
}
```

##### Pros
- Code is smaller and easier to understand

##### Cons
- More effort to expand ranges as lists in the Object