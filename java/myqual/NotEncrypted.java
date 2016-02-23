package myqual;

import java.lang.annotation.ElementType;
import java.lang.annotation.Target;
import javax.lang.model.type.TypeKind;
import org.checkerframework.framework.qual.*;


/**
 * Denotes that the representation of an object is not encrypted.
 */
@SubtypeOf(PossiblyUnencrypted.class)
@ImplicitFor(types = { TypeKind.INT })
@Target({ElementType.TYPE_USE, ElementType.TYPE_PARAMETER})
public @interface NotEncrypted {}
