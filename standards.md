layout: default
title: Yarrow - Simple Documentation Generator for PHP
---

Yarrow Code Standards
=====================

Pretty basic stuff. This document is available under the Creative Commons Documentation License, so feel free to clone and modify to suit your own purposes.

Namespacing and Package Structure
---------------------------------

Currently using a single pseudo-namespace and no explicit package structure.

Naming Conventions
------------------

Classes must be named in CamelCase notation with an uppercase first letter. Class names should be simple and clearly reflect the concept of what the class does, following from the 'Single Responsibility Principle'. Assume that this will change, to support PEAR conventions, ie: Analyzer becomes Yarrow_Analyzer.

Methods must be named in camelCase notation with a lowercase first letter. Method names should describe the action and purpose of the method, using a predicate phrase that is as specific as possible.

Internal variables and class properties must also be named in camelCase notation with a lowercase first letter.

Global and class constants must be named in ALL_CAPS with underscores used to separate each word.


Indenting And Brace Structure
-----------------------------

Spaces not tabs should be used for indentation. Braces should start on the same line as the declaration or logic statement that opens the scope, and end on their own line.

Class declarations should start at the beginning of a newline, with no preceding whitespace. Trailing braces that close a class scope should be placed on the line immediately following the brace closing the preceding method, with no whitespace or additional newlines inserted.

ie:

class ClassConvention {

    private function method() {
        $this->doInternals();
    }
}

Docblocks are optional (ironic for a documentation generator, but significant in the sense that the project will soon be parsing itself to test itself, and needs a general variety of). All public methods should have docblocks which explain the usage of the method and describe each individual parameter.

Classes
-------



Methods
-------

Methods should be kept to less than 10 lines of code and be responsible for a single logical action. They should never require more than 3 parameters, except in special or extreme cases. Mixed parameter types are acceptable in contexts where such flexibility is easy to understand and does not corrupt or confuse the API. Methods should always return a single type.

Format of documentation comments should be in the standard PHP docblock syntax, with the initial line being a plain text summary of what the method does. @param and @return tags should be used to describe parameters and return type.



