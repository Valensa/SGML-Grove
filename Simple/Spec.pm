#
# Copyright (C) 1997 Ken MacLeod
# See the file COPYING for distribution terms.
#
# $Id: Spec.pm,v 1.2 1998/01/18 00:21:22 ken Exp $
#

=head1 NAME

SGML::Simple::Spec - a simple transformation specification

=head1 SYNOPSIS

    use SGML::SPGroveBuilder;
    use SGML::Simple::Spec;
    use SGML::Simple::SpecBuilder;
    use SGML::Simple::BuilderBuilder;

    $spec_grove = SGML::SPGroveBuilder->new ($spec_sysid);
    $spec = SGML::Simple::Spec->new;
    $spec_grove->accept (SGML::Simple::SpecBuilder->new, $spec);
    $builder = SGML::Simple::BuilderBuilder->new (spec => $spec);

=head1 DESCRIPTION

A C<SGML::Simple::Spec> object containing C<SGML::Simple::Spec::Rule>
objects is built by the C<SpecBuilder> module from a grove of a simple
specification file.

C<SGML::Simple::Spec> and C<SGML::Simple::Spec::Rule> inherit all
methods from C<Class::Visitor> and C<Class::Template>.  Fields are
defined below.

C<Spec> objects are passed to C<SGML::Simple::BuilderBuilder> to build
a Perl package for transforming other SGML groves.

=head2 C<SGML::Simple::Spec>

C<SGML::Simple::Spec> contains the following fields:

    default_prefix, default_object

C<default_prefix> defines the default package prefix to be used for
objects being created during a transform.  C<default_object> defines an
object to be created when a C<make> field is undefined in a rule.

    rules  --  an array

C<rules> contains the global set of rules for this transformation.

    stuff

C<stuff> contains extra Perl code to be added as part of the new
package.

=head2 C<SGML::Simple::Spec::Rule>

C<SGML::Simple::Spec::Rule> defines a single transformation rule and
contains the following fields:

    query

A space seperated list of generic identifiers that this rule applies
to.

    holder

A flag indicating that this element merely contains other elements.
No objects are created during the transformation.

    ignore

A flag indicating that this element should be ignored.  No objects are
created during the transformation and no elements contained in this
element are processed.

    make

The package name of an object to be created for this rule.  An object
in the `C<make>' package is created to hold any elements contained in
this element.

    port

A field name in the parent object to append this object to.  If
not defined, this object is added to the parent's `contents' field.

    rules  --  an array

Rules that apply only within the current element.

    code

If code is defined it is used in place of any code that would have
been generated by C<BuilderBuilder>, all other fields are ignored.
Code for a holder element looks like this:

    my $self = shift; my $element = shift; my $parent = shift;
    $element->children_accept_gi ($self, $parent, @_);

Code for creating a new object looks like this:

    my $self = shift; my $element = shift; my $parent = shift;
    my $obj = My::Object->new;
    $parent->push ($obj);
    $element->children_accept_gi ($self, $obj, @_);

Code for switching a set of rules (the current ``builder'') looks like
this:

    my $self = shift; my $element = shift; my $parent = shift;
    $new_builder = Another::Builder->new;
    $element->children_accept_gi ($new_builder, $obj, @_);

=head1 AUTHOR

Ken MacLeod, ken@bitsko.slc.ut.us

=head1 SEE ALSO

  perl(1), SGML::Grove(3), SGML::Simple::SpecBuilder(3),
  SGML::Simple::BuilderBuilder(3), Class::Visitor(3),
  Class::Template(3)

=cut

use Class::Visitor;

visitor_class 'SGML::Simple::Spec', 'Class::Visitor::Base', {
    default_object => '$',
    default_prefix => '$',
    use_gi => '$',
    copy_id => '$',
    rules => '@',
    stuff => '$',
};

visitor_class 'SGML::Simple::Spec::Rule', 'Class::Visitor::Base', {
    query => '$',
    code => '$',
    holder => '$',
    ignore => '$',
    make => '$',
    port => '$',
    rules => '@',
};

1;
