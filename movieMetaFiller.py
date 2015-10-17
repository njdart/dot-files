#!/usr/bin/env python3

import argparse
import os
import urllib.request
import urllib.parse
import mutagen
import re
import json
import sys

print("""This program uses the OMDb API, and queries their site quite frequently, Consider supporting them or setting a delay""")

# parser = argparse.ArgumentParser(description="Add movie Information to movie(s)")

# parser.add_argument("Source", type=argparse.FileType("d"), help="Location of Movie or directory of movies")
# TODO: File types exclude
# TODO: File type Include
# TODO: Movie Posters
# TODO: Dry Run

# args = parser.parse_args()
# print(args)


class MovieNotFoundException(Exception):
  def __init__(self, query):
    self.query = query
  def __str__(self):
    return "No Movie found with query " + str(self.query)


class OMDbAPI(object):

  # Base OMDb Url
  omdbUri = "http://omdbapi.com"

  query = {
    "r": "json",
    "plot": "short",
    "tomatoes": "false",
    "type": "movie"
  }
  # Query paramaters, Either queryTitle or queryImdbId or search string are required
  queryTitle = "t"
  queryImdbId = "i"
  querySearch = "s"

  def __init__(self):
    self.url = urllib.parse.urlparse(self.omdbUri)
    if debug:
      print(self.url)

  def getPlotLength(self, length="short"):
    self.query["plot"] = length

  def getTomatoesRating(self, ratings=False):
    self.query["tomatoes"] = "true" if ratings else "false"

  def setType(self, type="movie"):
    self.query["type"] = type

  def setTitle(self, title):
    #remove any existing search
    if self.querySearch in self.query:
      del self.query[self.querySearch]

    # remove any existing ids
    if self.queryImdbId in self.query:
      del self.query[self.queryImdbId]

    self.query[self.queryTitle] = title

  def setImdbId(self, id):
    # remove any existing title
    if self.queryTitle in self.query:
      del self.query[self.queryTitle]

    #remove any existing search
    if self.querySearch in self.query:
      del self.query[self.querySearch]

    self.query[self.queryTitle] = id

  def setSearch(self, searchTerm):
    # remove any existing title
    if self.queryTitle in self.query:
      del self.query[self.queryTitle]

    # remove any existing ids
    if self.queryImdbId in self.query:
      del self.query[self.queryImdbId]

    self.query[self.querySearch] = searchTerm

  def isQueriable(self):
    return self.queryImdbId in self.query or self.queryTitle in self.query or self.querySearch in self.query

  def request(self):
    
    if not self.isQueriable():
      raise Exception("Either a title or IMDb Movie ID must be provided to make a query")

    # enocde the url tuple object
    encodedQuery = urllib.parse.urlencode(self.query)

    #rebuild the query
    urlTuple = (self.url.scheme,
                self.url.netloc,
                self.url.path,
                self.url.params,
                encodedQuery,
                self.url.fragment)
    queryUrl = urllib.parse.urlunparse(urlTuple)

    if debug:
      print(queryUrl)

    with urllib.request.urlopen(queryUrl) as response:
      stringResponse = response.read().decode("utf-8")
      jsonResponse = json.loads(stringResponse)
      

      if "Error" in jsonResponse:
        raise MovieNotFoundException(self.query)

    return jsonResponse


if __name__ == "__main__":

  regexReplaces = [
    {"find": re.compile(r"\..+?$"), "replace": ""},
    {"find": re.compile(r"[-_]+"), "replace": " "},
    {"find": re.compile(r"\.title[0-9]+$"), "replace": ""}
  ]

  imdbIdRegexMatch = re.compile(r"^tt[0-9]{7}$")

  debug = False

  for root, dirs, files in os.walk("/media/music/Movies"):
    filesLen = len(files)
    for file in files:
      fileIndex = files.index(file)

      name, ext = os.path.splitext(root + "/" + file)

      if ext != ".mp4":
        print("CURRENTLY UNSUPORTED FILETYPE {}".format(file))
        continue

      mutagenHandler = mutagen.File(root + "/" + file, easy=True)

      if debug:
        print("file: " + str(file) + " made mutagenHandler " + str(mutagenHandler))

      if mutagenHandler["album"]:
        if imdbIdRegexMatch.match(mutagenHandler["album"][0]):
          print("Skipping file " + file)
          continue

      guessedName = file
      for regex in regexReplaces:
        guessedName = re.sub(regex["find"], regex["replace"], guessedName)

      print("Working on file '{}', Guessed '{}' ({}/{}) {}%".format(root + "/" + file, guessedName, fileIndex+1, filesLen, round(1000 * ( (1+fileIndex) / filesLen ) )/10))


      found = False

      omdb = OMDbAPI()
      omdb.setTitle(guessedName)
      while not found:
        try:

          data = omdb.request()

          mutagenHandler["title"] = data["Title"]
          mutagenHandler["artist"] = data["Director"]
          mutagenHandler["comment"] = data["Plot"]
          mutagenHandler["album"] = data["imdbID"]

          print("Writing movie " + str(file))
          mutagenHandler.save()
          found = True
        except MovieNotFoundException as notFound:
          print(" => No Movie found for Guess '{}'".format(guessedName))

          choice = input(" => What do you want to do? [s]earch, s[K]ip, [m]anual, [a]bort => ").lower()
          if choice in ["s", "search"]:
            searchResultsFound = False

            while not searchResultsFound:
              try:
                searchTerm = input(" ==> Enter Search String => ")
                omdb.setSearch(searchTerm)
                searchResults = omdb.request()["Search"]
                searchResultsFound = True
              except MovieNotFoundException as e:
                print(" ==> No Movies found for search term " + searchTerm)

            resultNumberLen = len(str(len(searchResults)))

            print("[{}] Abort".format(str(0).zfill(resultNumberLen)))

            for i in range(len(searchResults)):
              print("[{}] Y: {} ID: {}\t{}".format(str(i+1).zfill(resultNumberLen), searchResults[i]["Year"], searchResults[i]["imdbID"], searchResults[i]["Title"]))

            
            selected = None
            while selected == None:
              try:
                selected = int(input("Please select a choice => "))
                if selected < 0 or (selected - 1) >= len(searchResults):
                  selected = None
              except Exception as e:
                print(e)

            if selected == 0:
              print(" ==> Aborting")
            else:
              omdb.setTitle(searchResults[selected-1]["Title"])


          elif choice in ["k", "skip"]:
            print(" => Skipping")
            break

          elif choice in ["m", "manual"]:
            omdb.setTitle(input("Enter Title: "))


          elif choice in ["a", "abort"]:
            print("Aborting, all previous Movie writes will remain")
            sys.exit(0)