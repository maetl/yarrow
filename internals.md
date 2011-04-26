---
layout: default
title: Yarrow - Programming Notes
---

Yarrow: Internals
=================

Roughly, the Yarrow processing pipeline is divided into two main stages:

  - Input
  - Output

The input stage starts with a path to the PHP code to document, and results in
a tree of objects representing the analyzed source code.

This tree of objects is passed to the output stage, where a generator applies
a map of files to output and supplies this context to a template converter
which is responsible for actually generating the output content.

In more detail:

  - Input
     - Map of input source files
     - Tokenize each source file
     - Parse an object tree from token stream
       - Parse docblock syntax for comment tokens
     - Append object tree for file/class to global object tree
  - Output
     - Construct generator with object tree context
     - Run generator
       - Run template converter for each output object
       - Write file to output target for each rendered template
       - Copy/render static files to output target

The main extension point is at the Generator stage.

The generator contains two template methods: getTemplateMap() and getObjectMap()
which are used to specify the set of output objects to render.

getObjectMap provides the set of individual objects to render as files, wheras
getTemplateMap provides a mapping between template files and the object index.

To render output as a single index.html file, implement an array with a single index:

class SingleFileOutputGenerator {

	/**
	 * Specifies that the 'index.tpl' template should be used to render 
	 * the 'index' object.
	 */
	function getTemplateMap() {
		return array('index' => 'index.tpl');
	}
	
	/**
	 * Specifies that the index object consists of a single file
	 * called 'index'.
	 */
	function getObjectMap() {
		return array('index' => array('index'));
	}
}

To render a matching documentation file for every PHP source file in the project:

class CodeFileOutputGenerator {

	/**
	 * Specifies that the 'file.tpl' template should be used to render 
	 * 'file' objects.
	 */
	function getTemplateMap() {
		return array('file' => 'file.tpl');
	}
	
	/**
	 * Sets the index of file objects to the list of files collected from the project.
	 */
	function getObjectMap() {
		return array('file' => $this->objectModel->getFiles());
	}
}

Rendering a documentation file for each PHP class in the project is similar:

class ClassFileOutputGenerator {

	/**
	 * Specifies that the 'file.tpl' template should be used to render 
	 * 'file' objects.
	 */
	function getTemplateMap() {
		return array('class' => 'class.tpl');
	}
	
	/**
	 * Sets the index of class objects to the list of classes collected from the project.
	 */
	function getObjectMap() {
		return array('class' => $this->objectModel->getClasses());
	}
}

These methods can be mixed and matched to build all kinds of custom documentation structures,
with the caveat that the arrays returned by getTemplateMap and getObjectMap must contain
matching indexes.

The default generators provided by Yarrow are:

  - SingleIndexGenerator
  - ClassFileGenerator
  - PEARPackageGenerator

(None of these exist yet!)

Configuration
-------------

Currently experimenting with a configuration format based on the .ini syntax, but using colons as delimiters rather than the equals symbol. Also supporting conversion to internal types for values. Currently only arrays.

[section]
property: value
property2: value

[section2]
boolean: true
list: one,two,three

Now the question has to be what actual sections and properties should be supported (so that we can validate).

If a .yarrowdoc file is not provided in the project root, and an alternative configuration is not provided,
then we should generate a base config from default settings.

 Sections:

 Meta [meta]
   The meta properties will be passed in the global context to each template.

 Input [input]
   Specify input and output patterns for file collector?
   Specify particular docblock syntax and package structure?
   Specify PHP version and particular settings on code structure (ignore properties/protected methods)

 Output [output]
   Set selected generator, template converter, and theme
   
 Helpers [helpers]
   Register helper classes and stuff with the include_path? Need to work out a definitive way for this.


Usage Sketch
------------

Usage:

 $ yarrow <input> <output> [options]

 <input>  - Path to PHP code files or an individual PHP file.
 <output> - Path to the generated documentation. If the directory does 
            not exist, it is created. If it does exist, it is 
            overwritten.

 Options

  Use -o or --option for boolean switches and --option=value or --option:value
  for options that require an explicit value to be set.

  -h    --help     [switch]   Display this help message
  -v    --version  [switch]   Display package version
  -d    --dry      [switch]   Dry run. Parses the code and gives warnings,
                              but doesn’t build output.
  -p    --package  [string]   Package structure. Used to determine organization
                              of the code into packages. Must be one of the
                              following:
                                - namespace (use PHP 5.3 namespace convention)
                                - pear (use PEAR package naming conventions)
                                - tags (use @package and @subpackage tags)
                                - folder (treat directories as package names)
                                - none (do not group code into packages)
  -t    --template [string]   Output templates to use.
  -


yarrow 

Doc Comment Styles
------------------

##
# Function name
# - Public
# - Something else
#
function doSomethingElse() {
}

// This is a comment about something.
// 
// This is a comment description that goes on for longer and longer.
// This is a comment description that goes on for longer and longer.
// This is a comment description that goes on for longer and longer.
//
function doSomething() {
}

/**
 * A docblock (we all know what these are)
 *
 * @annotation value
 * @anotherAnnotation value
 */
function doSomethingFast() {
}

/*==================================================
FOUND THIS STYLE USED IN SOME PARTICLETREE.COM CODE
====================================================*/
function doSomethingElse() {
}

Note: make sure docblocks operate independently of whitespace, eg:

/**
 * A docblock with line breaks in-front of the method declaration
 */

function doSomethingFast() {
}


List of all tags supported by phpDocumentor
-------------------------------------------

@abstract
@access
@author
@category
@copyright
@deprecated
@example
@final
@filesource
@global
@ignore
@internal
@license
@link
@method
@name
@package
@param
@property
@return
@see
@since
@static
@staticvar
@subpackage
@todo
@tutorial
@uses
@var
@version
inline {@example}
inline {@id}
inline {@internal}}
inline {@inheritdoc}
inline {@link}
inline {@source}
inline {@toc}
inline {@tutorial}


List of all tags supported by YARD
-------------------------------------------

@abstract: Marks a class/module/method as abstract with optional implementor information.
@abstract Subclass and override {#run} to implement a custom Threadable class.
@api: Declares the API that the object belongs to. Does not display in output, but useful for performing queries (yardoc --query). Any text is allowable in this tag, and there are no predefined values(*).
@api freeform text
(*) Note that the special name @api private does display a notice in documentation if it is listed, letting users know that the method is not to be used.
@attr: Declares an attribute from the docstring of a class. Meant to be used on Struct classes only (classes that inherit Struct).
@attr [Types] attribute_name a full description of the attribute
@attr_reader: Declares a readonly attribute from the docstring of a class. Meant to be used on Struct classes only (classes that inherit Struct). See @attr.
@attr_reader [Types] name description of a readonly attribute
@attr_writer: Declares a writeonly attribute from the docstring of class. Meant to be used on Struct classes only (classes that inherit Struct). See @attr.
@attr_writer [Types] name description of writeonly attribute
@author: List the author(s) of a class/method
@author Full Name
@deprecated: Marks a method/class as deprecated with an optional reason.
@deprecated Describe the reason or provide alt. references here
@example: Show an example snippet of code for an object. The first line is an optional title.
@example Reverse a string
  "mystring".reverse #=> "gnirtsym"
@note: Creates an emphasized note for the users to read about the object.
@note This method should only be used in outer space.
@option: Describe an options hash in a method. The tag takes the name of the options parameter first, followed by optional types, the option key name, an optional default value for the key and a description of the option.
# @param [Hash] opts the options to create a message with.
# @option opts [String] :subject The subject
# @option opts [String] :from ('nobody') From address
# @option opts [String] :to Recipient email
# @option opts [String] :body ('') The email's body 
def send_email(opts = {})
end 
@overload: Describe that your method can be used in various contexts with various parameters or return types. The first line should declare the new method signature, and the following indented tag data will be a new documentation string with its own tags adding metadata for such an overload.
# @overload set(key, value)
#   Sets a value on key
#   @param [Symbol] key describe key param
#   @param [Object] value describe value param
# @overload set(value)
#   Sets a value on the default key `:foo`
#   @param [Object] value describe value param
def set(*args)
end
@param: Defines method parameters
@param [optional, types, ...] argname description
@private: Defines an object as private. This exists for classes, modules and constants that do not obey Ruby's visibility rules. For instance, an inner class might be considered "private", though Ruby would make no such distinction. By declaring the @private tag, the class can be hidden from documentation by using the --no-private command-line switch to yardoc (see {file:README.md}).
@private
@raise: Describes an Exception that a method may throw
@raise [ExceptionClass] description
@return: Describes return value of method
@return [optional, types, ...] description
@see: "See Also" references for an object. Accepts URLs or other code objects with an optional description at the end.
@see http://example.com Description of URL
@see SomeOtherClass#method
@since: Lists the version the feature/object was first added
@since 1.2.4
@todo: Marks a TODO note in the object being documented
@todo Add support for Jabberwocky service
  There is an open source Jabberwocky library available 
  at http://somesite.com that can be integrated easily
  into the project.
@version: Lists the version of a class, module or method
@version 1.0
@yield: Describes the block. Use types to list the parameter names the block yields.
# for block {|a, b, c| ... }
@yield [a, b, c] Description of block
@yieldparam: Defines parameters yielded by a block
@yieldparam [optional, types, ...] argname description
@yieldreturn: Defines return type of a block
@yieldreturn [optional, types, ...] description



References
----------

Giriprasad Sridhara, Emily Hill, Divya Muppaneni, Lori Pollock, and K. Vijay-Shanker. 2010. Towards automatically generating summary comments for Java methods. In Proceedings of the IEEE/ACM international conference on Automated software engineering (ASE '10). ACM, New York, NY, USA, 43-52. DOI=10.1145/1858996.1859006 http://doi.acm.org/10.1145/1858996.1859006

- Possible Google Summer of Code Project?

