# STATUS
[![Build Status](https://travis-ci.org/daviemakz/reconciliation.svg?branch=master)](https://travis-ci.org/daviemakz/reconciliation)
[![Issue Count](https://codeclimate.com/github/daviemakz/reconciliation/badges/issue_count.svg)](https://codeclimate.com/github/daviemakz/reconciliation)

# SUMMARY

Securities lending is the act of loaning a stock, derivative or other security to an investor or firm. After a trade is complete it goes through post-trade processing, where the buyer and the seller compare trade details, approve the transaction, change records of ownership and arrange for the transfer of securities and cash.

This is a small repository which performs reconciliation between the trades of two clients and lets you know if any data is missing or invalid. So if trades or returns are missing from either side this information will be shown as well as discrepancies in quantity of stock traded.

# HOW TO INSTALL

To install the application run the following commands:

    perl Makefile.PL
    make
    make test
    make install

# HOW TO RUN

To execute *without installing* run the following command:

    bin/start

To execute *after installing* the program run the following command in your terminal:

    play-match

# TESTS

To run manual tests navigate to the repository root directory and execute:

    prove

or

    make test

Enjoy!
