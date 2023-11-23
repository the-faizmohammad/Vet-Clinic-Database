-- Query 1
SELECT * FROM animals WHERE name LIKE '%mon';

-- Query 2
SELECT name FROM animals WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';

-- Query 3
SELECT name FROM animals WHERE neutered = true AND escape_attempts < 3;

-- Query 4
SELECT date_of_birth FROM animals WHERE name IN ('Agumon', 'Pikachu');

-- Query 5
SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;

-- Query 6
SELECT * FROM animals WHERE neutered = true;

-- Query 7
SELECT * FROM animals WHERE name <> 'Gabumon';

-- Query 8
SELECT * FROM animals WHERE weight_kg BETWEEN 10.4 AND 17.3;

-- Transaction 1: Update species to 'unspecified' and roll back
BEGIN;
UPDATE animals SET species = 'unspecified';
SELECT * FROM animals; -- Verify the change
ROLLBACK;
SELECT * FROM animals; -- Verify rollback

-- Transaction 2: Update species based on conditions and commit
BEGIN;
UPDATE animals SET species = 'digimon' WHERE name LIKE '%mon';
UPDATE animals SET species = 'pokemon' WHERE species IS NULL;
SELECT * FROM animals; -- Verify changes
COMMIT;
SELECT * FROM animals; -- Verify changes persist after commit

-- Transaction 3: Delete all records and roll back
BEGIN;
DELETE FROM animals;
SELECT * FROM animals; -- Verify deletion
ROLLBACK;
SELECT * FROM animals; -- Verify rollback

-- Transaction 4: Delete animals born after Jan 1, 2022, and update weights
BEGIN;
DELETE FROM animals WHERE date_of_birth > '2022-01-01';
SAVEPOINT weight_update;
UPDATE animals SET weight_kg = weight_kg * -1;
ROLLBACK TO weight_update;
UPDATE animals SET weight_kg = ABS(weight_kg) WHERE weight_kg < 0;
COMMIT;
SELECT * FROM animals; -- Verify changes

-- Additional Queries

-- How many animals are there?
SELECT COUNT(*) FROM animals; 
-- How many animals have never tried to escape?
SELECT COUNT(*) FROM animals WHERE escape_attempts = 0;
-- What is the average weight of animals?
SELECT AVG(weight_kg) FROM animals; 
-- Who escapes the most, neutered or not neutered animals?
SELECT neutered, MAX(escape_attempts) FROM animals GROUP BY neutered;
 -- Minimum and maximum weight of each type of animal
SELECT species, MIN(weight_kg), MAX(weight_kg) FROM animals GROUP BY species;
 -- Average escape attempts per animal type born between 1990 and 2000
SELECT AVG(escape_attempts) FROM animals WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31';
