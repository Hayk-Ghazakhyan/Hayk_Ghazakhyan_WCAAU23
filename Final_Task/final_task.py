"""
Module for preparing inverted indexes based on uploaded documents
"""

import json
import re
import sys
from argparse import ArgumentParser, ArgumentTypeError, FileType
from io import TextIOWrapper
from typing import Dict, List

DEFAULT_PATH_TO_STORE_INVERTED_INDEX = "inverted.index"


class EncodedFileType(FileType):
    """File encoder"""

    def __call__(self, string):
        # the special argument "-" means sys.std{in,out}
        if string == "-":
            if "r" in self._mode:
                stdin = TextIOWrapper(sys.stdin.buffer, encoding=self._encoding)
                return stdin
            if "w" in self._mode:
                stdout = TextIOWrapper(sys.stdout.buffer, encoding=self._encoding)
                return stdout
            msg = 'argument "-" with mode %r' % self._mode
            raise ValueError(msg)

        # all other arguments are used as file names
        try:
            return open(string, self._mode, self._bufsize, self._encoding, self._errors)
        except OSError as exception:
            args = {"filename": string, "error": exception}
            message = "can't open '%(filename)s': %(error)s"
            raise ArgumentTypeError(message % args)

    def print_encoder(self):
        """printer of encoder"""
        print(self._encoding)


class InvertedIndex:
    """
    This module is necessary to extract inverted indexes from documents.
    """

    def __init__(self, words_ids: Dict[str, List[int]]):
        self.words_ids = words_ids

    def query(self, words: List[str]) -> List[int]:
        """Return the list of relevant documents for the given query"""
        # create set to store unique values
        relevant_documents = set()
        # add first value(s) into set
        if words[0] in self.words_ids:
            relevant_documents.update(self.words_ids[words[0]])
        # based on first values we add the rest in the set to avoid duplicates
        for word in words[1:]:
            if word in self.words_ids:
                relevant_documents.intersection_update(self.words_ids[word])
        return list(relevant_documents)

    def dump(self, filepath: str) -> None:
        """
        Allow us to write inverted indexes documents to temporary directory or local storage
        :param filepath: path to file with documents
        :return: None
        """
        # Inverted_index date to be written to json file
        with open(filepath, "w") as outfile:
            json.dump(self.words_ids, outfile)

    @classmethod
    def load(cls, filepath: str):
        """
        Allow us to upload inverted indexes from either temporary directory or local storage
        :param filepath: path to file with documents
        :return: InvertedIndex
        """
        # load data from json file to use in the query function and store in variable inverted_index
        with open(filepath, "r") as infile:
            inverted_index = json.load(infile)
        return cls(inverted_index)


def load_documents(filepath: str) -> Dict[int, str]:
    """
    Allow us to upload documents from either tempopary directory or local storage
    :param filepath: path to file with documents
    :return: Dict[int, str]
    """
    # open the file, get it in dict split and change to lowercase
    with open(filepath, "r", encoding="utf-8") as src_file:
        dict_file = {}
        for line in src_file:
            doc_id, content = line.lower().split("\t", 1)
            dict_file[int(doc_id)] = content
        return dict_file


def build_inverted_index(documents: Dict[int, str]) -> InvertedIndex:
    """
    Builder of inverted indexes based on documents
    :param documents: dict with documents
    :return: InvertedIndex class
    """
    # get stop words into list stop_words
    with open(
        r"C:\Users\user\Hayk_Ghazakhyan_WCAAU23\Python-Course\Final_Task\stop_words_en.txt",
        "r",
        encoding="utf-8",
    ) as stop_words_file:
        stop_words = [word.strip().lower() for word in stop_words_file.readlines()]
    # create dict to add inverted index using .items
    dict_inverted_index = {}
    for doc_id, content in documents.items():
        # Split content in to words an add in a list
        words = re.split(
            r"\W+", content
        )  # re.findall(r"\b\w+\b", content) - doesn't keep spaces
        # used the option that Egor provided but id keeps spaces
        words = [word for word in words if word not in stop_words]
        for word in set(words):
            if word not in dict_inverted_index:
                dict_inverted_index[word] = [doc_id]
            elif doc_id not in dict_inverted_index[word]:
                dict_inverted_index[word].append(doc_id)
            # returned dict inverted index as InvertedIndex classes object
    return InvertedIndex(dict_inverted_index)


def callback_build(arguments) -> None:
    """process build runner"""
    return process_build(arguments.dataset, arguments.output)


def process_build(dataset, output) -> None:
    """
    Function is responsible for running of a pipeline to load documents,
    build and save inverted index.
    :param arguments: key/value pairs of arguments from 'build' subparser
    :return: None
    """
    documents: Dict[int, str] = load_documents(dataset)
    inverted_index = build_inverted_index(documents)
    inverted_index.dump(output)


def callback_query(arguments) -> None:
    """ "callback query runner"""
    process_query(arguments.query, arguments.index)


def process_query(queries, index) -> None:
    """
    Function is responsible for loading inverted indexes
    and printing document indexes for key words from arguments.query
    :param arguments: key/value pairs of arguments from 'query' subparser
    :return: None
    """
    inverted_index = InvertedIndex.load(index)
    for query in queries:
        print(query[0])
        if isinstance(query, str):
            query = query.strip().split()

        doc_indexes = ",".join(str(value) for value in inverted_index.query(query))
        print(doc_indexes)


def setup_subparsers(parser) -> None:
    """
    Initial subparsers with arguments.
    :param parser: Instance of ArgumentParser
    """
    subparser = parser.add_subparsers(dest="command")
    build_parser = subparser.add_parser(
        "build",
        help="this parser is need to load, build"
        " and save inverted index bases on documents",
    )
    build_parser.add_argument(
        "-d",
        "--dataset",
        required=True,
        help="You should specify path to file with documents. ",
    )
    build_parser.add_argument(
        "-o",
        "--output",
        default=DEFAULT_PATH_TO_STORE_INVERTED_INDEX,
        help="You should specify path to save inverted index. "
        "The default: %(default)s",
    )
    build_parser.set_defaults(callback=callback_build)

    query_parser = subparser.add_parser(
        "query", help="This parser is need to load and apply inverted index"
    )
    query_parser.add_argument(
        "--index",
        default=DEFAULT_PATH_TO_STORE_INVERTED_INDEX,
        help="specify the path where inverted indexes are. " "The default: %(default)s",
    )
    query_file_group = query_parser.add_mutually_exclusive_group(required=True)
    query_file_group.add_argument(
        "-q",
        "--query",
        dest="query",
        action="append",
        nargs="+",
        help="you can specify a sequence of queries to process them overall",
    )
    query_file_group.add_argument(
        "--query_from_file",
        dest="query",
        type=EncodedFileType("r", encoding="utf-8"),
        # default=TextIOWrapper(sys.stdin.buffer, encoding='utf-8'),
        help="query file to get queries for inverted index",
    )
    query_parser.set_defaults(callback=callback_query)


def main():
    """
    Starter of the pipeline
    """
    parser = ArgumentParser(
        description="Inverted Index CLI is need to load, build,"
        "process query inverted index"
    )
    setup_subparsers(parser)
    arguments = parser.parse_args()
    arguments.callback(arguments)


if __name__ == "__main__":
    main()
