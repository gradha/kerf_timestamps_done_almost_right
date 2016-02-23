package myqual;

import java.lang.annotation.ElementType;
import java.lang.annotation.Target;
import javax.lang.model.type.TypeKind;
import org.checkerframework.framework.qual.*;


/**
 * Default annotation for longs, 
 */
@SubtypeOf(Base.class)
@ImplicitFor(types = { TypeKind.LONG })
@Target({ElementType.TYPE_USE, ElementType.TYPE_PARAMETER})
public @interface Plain {}
