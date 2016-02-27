package myqual;

import java.lang.annotation.Target;
import java.lang.annotation.ElementType;
import org.checkerframework.framework.qual.SubtypeOf;

/**
 * Denotes that the representation of a long containing a Stamp value.
 */
@SubtypeOf(Base.class)
@Target({ElementType.TYPE_USE, ElementType.TYPE_PARAMETER})
public @interface Stamp {}
