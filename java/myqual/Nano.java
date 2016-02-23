package myqual;

import java.lang.annotation.Target;
import java.lang.annotation.ElementType;
import org.checkerframework.framework.qual.SubtypeOf;
import org.checkerframework.framework.qual.TypeQualifier;

/**
 * Denotes that the representation of a long containing a Nano value.
 */
@SubtypeOf(Base.class)
@Target({ElementType.TYPE_USE, ElementType.TYPE_PARAMETER})
public @interface Nano {}
