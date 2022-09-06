import androidx.compose.animation.*
import androidx.compose.animation.core.*
import androidx.compose.foundation.*
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Phone
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.geometry.Rect
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.Path
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.intl.Locale
import androidx.compose.ui.text.toUpperCase
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.IntSize
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp

@Composable
fun CrossFade() {
    Column(
        modifier = Modifier.fillMaxSize(),
        verticalArrangement = Arrangement.Center,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        var currentPage by remember { mutableStateOf(0) }
        Crossfade(
            targetState = currentPage,
            animationSpec = tween(durationMillis = 5000 )
        ) { screen -> Box(modifier = Modifier
            .fillMaxSize(0.8f)
            .background(Color(screen or 0xff000000.toInt()))) {
            Text(text = screen.toString(16),
                fontSize = 25.sp,
                modifier = Modifier
                    .align(Alignment.Center))
        }
        }
    }
}

// Based on https://github.com/elye/demo_android_jetpack_compose_animation

@Composable
fun Animation1() {
    Column {
        var enabled by remember { mutableStateOf(true) }
        val color = remember { Animatable(Color.Gray) }
        LaunchedEffect(enabled) {
            color.animateTo(
                if (enabled) Color.Green else Color.Red,
                animationSpec = tween(
                    durationMillis = 3000,
                    easing = LinearOutSlowInEasing
                )
            )
        }
        Box(
            Modifier
                .fillMaxWidth()
                .height(50.dp)
                .background(color.value))
        Button(onClick = { enabled = !enabled }) {
            Text("Click Me")
        }
    }
}

@Composable
fun Animation2() {
    Column {
        var enabled by remember {
            mutableStateOf(true)
        }
        val alpha: Float by animateFloatAsState(
            if (enabled) 1f else 0f,
            animationSpec = tween(
                durationMillis = 3000,
                easing = LinearOutSlowInEasing
            )
        )
        Box(
            Modifier
                .fillMaxWidth()
                .height(50.dp)
                .graphicsLayer(alpha = alpha)
                .background(Color.Red)
        )
        Button(onClick = { enabled = !enabled }) {
            Text("Click Me")
        }
    }
}

fun <T> animationSpec() = tween<T>(
    durationMillis = 3000,
    easing = LinearOutSlowInEasing
)

@OptIn(ExperimentalAnimationApi::class)
@Composable
fun Animation3() {

    Column(
        modifier = Modifier.fillMaxSize(),
        verticalArrangement = Arrangement.Center,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        var currentPage by remember { mutableStateOf(0) }

        Box {
            Crossfade(
                targetState = currentPage,
                animationSpec = animationSpec()
            ) { screen -> ColorBoxOnly(screen) }

            AnimatedContent(targetState = currentPage,
                transitionSpec = {
                    if (targetState > initialState) {
                        upColorTransition()
                    } else {
                        downColorTransition()
                    }.using(SizeTransform(clip = false))
                }
            ) { screen ->
                // Make sure to use `screen`, not `currentPage`.
                ColorBoxTextOnly(screen)
            }
        }
        Button(onClick = {
            currentPage = (0..0xFFFFFF).random()
        }) {
            Text("Click Me")
        }
    }
}

@OptIn(ExperimentalAnimationApi::class)
private fun downColorTransition() =
    slideInHorizontally(
        initialOffsetX = { fullWidth -> -fullWidth },
        animationSpec = animationSpec()
    ) + fadeIn(
        animationSpec = animationSpec()
    ) with slideOutVertically(
        targetOffsetY = { fullHeight -> fullHeight },
        animationSpec = animationSpec()
    ) + fadeOut(animationSpec = animationSpec())

@OptIn(ExperimentalAnimationApi::class)
private fun upColorTransition() =
    slideInHorizontally(
        initialOffsetX = { fullWidth -> fullWidth },
        animationSpec = animationSpec()
    ) + fadeIn(
        animationSpec = animationSpec()
    ) with slideOutVertically(
        targetOffsetY = { fullHeight -> -fullHeight },
        animationSpec = animationSpec()
    ) + fadeOut(animationSpec = animationSpec())

@Composable
fun ColorBoxOnly(screen: Int) {
    Box(
        Modifier
            .size(100.dp)
            .background(Color(screen + 0xFF000000))
    )
}

@Composable
fun ColorBoxTextOnly(screen: Int) {
    Box(
        Modifier.size(100.dp),
        contentAlignment = Alignment.Center
    ) {
        Text(get6DigitHex(screen), color = contrastColor(screen))
    }
}

fun get6DigitHex(value: Int): String {
    return "0x" + "%x".format(value).padStart(6, '0').toUpperCase(Locale.current)
}

fun contrastColor(color: Int): Color {
    return if (getLuma(color) < 0.5f)
        Color.White
    else
        Color.Black
}

fun getLuma(color: Int): Float {
    return ((color shr 16) and 0xff) / 255.0f * 0.2126f +
            ((color shr 8) and 0xff) / 255.0f * 0.7152f +
            ((color shr 8) and 0xff) / 255.0f * 0.0722f
}

@Composable
fun Animation4() {
    Column {
        var expanded by remember {
            mutableStateOf(false)
        }

        Image(
            painter = painterResource(
                if (expanded)
                    "img.png"
                else
                    "ic_launcher_background.xml"
            ),
            contentDescription = "",
            modifier = Modifier
                .background(Color.Yellow)
                .animateContentSize(tween(1500))
        )

        Button(onClick = { expanded = !expanded }) {
            Text(if (expanded) "Hide" else "Show")
        }
    }
}

@Composable
@OptIn(ExperimentalAnimationApi::class)
fun Animation5() {
    val time = 500
    Column {
        var expanded by remember {
            mutableStateOf(false)
        }

        AnimatedContent(
            targetState = expanded,
            transitionSpec = {
                if (targetState) {
                    expandFading(time) using expandSizing(time)
                } else {
                    shrinkFading(time) using shrinkSizing(time)
                }

            }
        ) { targetExpanded ->
            Image(
                painter = painterResource(
                    if (targetExpanded)
                        "img.png"
                    else
                        "ic_launcher_background.xml"
                ),
                contentDescription = "",
                modifier = Modifier.background(Color.Yellow)
            )
        }

        Button(onClick = { expanded = !expanded }) {
            Text(if (expanded) "Hide" else "Show")
        }
    }
}

@OptIn(ExperimentalAnimationApi::class)
private fun shrinkSizing(time: Int) =
    SizeTransform { initialSize, targetSize ->
        keyframes {
            // Shrink to target height first
            IntSize(initialSize.width, targetSize.height) at time
            // Then shrink to target width
            durationMillis = time * 3
        }
    }

@OptIn(ExperimentalAnimationApi::class)
private fun shrinkFading(time: Int) =
    fadeIn(animationSpec = tween(time, time * 2)) with
            fadeOut(animationSpec = tween(time * 3))


@OptIn(ExperimentalAnimationApi::class)
private fun expandSizing(time: Int) =
    SizeTransform { initialSize, targetSize ->
        keyframes {
            // Expand to target width first
            IntSize(targetSize.width, initialSize.height) at time
            // Then expand to target height
            durationMillis = time * 3
        }
    }

@OptIn(ExperimentalAnimationApi::class)
private fun expandFading(time: Int) =
    fadeIn(animationSpec = tween(time * 3)) with
            fadeOut(animationSpec = tween(time))

@OptIn(ExperimentalAnimationApi::class)
@Composable
fun Animation6() {
    var visible by remember {
        mutableStateOf(true)
    }

    var color by remember {
        mutableStateOf(Color.Black)
    }
    Column( Modifier.fillMaxSize()) {
        Button(onClick = { visible = !visible }) {
            Text(if (visible) "Hide" else "Show")
        }
        Box(modifier = Modifier.fillMaxWidth().height(30.dp).background(color))
        AnimatedVisibility(
            visible = visible,
            enter = fadeIn(animationSpec = tween(
                durationMillis = 3000,
                easing = LinearOutSlowInEasing
            )
            ),
            exit = fadeOut(animationSpec = tween(
                durationMillis = 3000,
                easing = LinearOutSlowInEasing
            )
            )
        ) {
            val background by transition.animateColor(label = "") { state ->
                when(state) {
                    EnterExitState.PreEnter -> Color.Red
                    EnterExitState.PostExit -> Color.Green
                    EnterExitState.Visible -> Color.Blue
                }
            }

            color = background

            Box(
                Modifier
                    .weight(1f)
                    .fillMaxWidth()
                    .background(background)
            ) {
                Box(
                    Modifier
                        .align(Alignment.Center)
                        .animateEnterExit(
                            // Slide in/out the inner box.
                            enter = slideInVertically(
                                animationSpec = tween(
                                    durationMillis = 3000,
                                    easing = LinearOutSlowInEasing
                                )
                            ),
                            exit = slideOutVertically(
                                animationSpec = tween(
                                    durationMillis = 3000,
                                    easing = LinearOutSlowInEasing
                                )
                            )
                        )
                        .sizeIn(minWidth = 256.dp, minHeight = 64.dp)
                        .background(Color.Red)
                ) {
                    // Content of the notification…
                }
            }
        }
    }
}
private val HesitateEasing = CubicBezierEasing(0f, 1f, 1f, 0f)

@OptIn(ExperimentalAnimationApi::class)
@Composable
fun Animation7() {
    var visible by remember {
        mutableStateOf(true)
    }
    Column(
        modifier = Modifier.fillMaxSize(),
        verticalArrangement = Arrangement.Center,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        AnimatedVisibility(
            visible = visible,
            enter = fadeIn(tween(1000)) + expandVertically (
                animationSpec = tween(1500)),
            exit = fadeOut(tween(1000)) + shrinkVertically (
                animationSpec = tween(1500))
        ) {
            Text(text = "Hello, world!")
        }
        Button(onClick = { visible = !visible }) {
            Text("Click Me")
        }
    }
}

@OptIn(ExperimentalAnimationApi::class)
@Composable
fun Animation8() {
    val state = remember {
        MutableTransitionState(false).apply {
            // Start the animation immediately.
            targetState = true
        }
    }
    Column(
        modifier = Modifier.fillMaxSize(),
        verticalArrangement = Arrangement.Center,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        AnimatedVisibility(
            visibleState = state,
            enter = fadeIn(tween(1000)) + expandVertically (
                animationSpec = tween(1500)),
            exit = fadeOut(tween(1000)) + shrinkVertically (
                animationSpec = tween(1500))
        ) {
            // Use the MutableTransitionState to know the current animation state
            // of the AnimatedVisibility.
            Text(text = when {
                state.isIdle && state.currentState -> "Hello, World!"
                !state.isIdle && state.currentState -> "Disappearing"
                state.isIdle && !state.currentState -> ""
                else -> "Appearing"
            })
        }
        Button(onClick = { state.targetState = !state.targetState }) {
            Text("Click Me")
        }
    }
}

@OptIn(ExperimentalAnimationApi::class)
@Composable
fun Animation9() {
    var visible by remember {
        mutableStateOf(true)
    }
    Column(
        modifier = Modifier.fillMaxSize(),
        verticalArrangement = Arrangement.Center,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Box(modifier = Modifier.height(20.dp)) {
            this@Column.AnimatedVisibility(
                visible = visible,
                enter = fadeIn(tween(1000)) + expandVertically(
                    animationSpec = tween(
                        1500
                    )
                ),
                exit = fadeOut(tween(1000)) + shrinkVertically(
                    animationSpec = tween(
                        1500
                    )
                )
            ) {
                Text(text = "Hello, world!")
            }
        }
        Button(onClick = { visible = !visible }) {
            Text("Click Me")
        }
    }
}


@Composable
fun Animation10() {
    var enabled by remember { mutableStateOf(false) }

    val dbAnimateAsState: Dp by animateDpAsState(
        targetValue = switch(enabled),
        animationSpec = if (enabled) animationSpec() else bounceAnimationSpec()
    )

    val dbAnimatable = remember { Animatable(0.dp) }

    val transition = updateTransition(enabled, label = "")
    val dbTransition by transition.animateDp(
        transitionSpec = {
            if (targetState) {
                animationSpec()
            } else {
                bounceAnimationSpec()
            }
        }, label = ""
    ) {
        switch(it)
    }

    Column(
        modifier = Modifier.fillMaxSize(),
        verticalArrangement = Arrangement.Center,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {

        Text("AnimateAsState")
        animateBoxHorizontal(dbAnimateAsState)
        Text("Animatable")
        animateBoxHorizontal(dbAnimatable.value)
        Text("UpdateTransition")
        animateBoxHorizontal(dbTransition)

        Button(onClick = { enabled = !enabled }) {
            Text("Click Me")
        }
    }

    LaunchedEffect(key1 = enabled) {
        dbAnimatable.animateTo(
            targetValue = switch(enabled),
            animationSpec = if (enabled) animationSpecSpring() else bounceAnimationSpec()
        )
    }
}

private fun animationSpecSpring(): SpringSpec<Dp> =
    spring(stiffness =20f, dampingRatio = 0.25f)

private fun bounceAnimationSpec(): TweenSpec<Dp> =
    tween(
        durationMillis = 3000
    )

private fun switch(enabled: Boolean) = if (enabled) 268.dp else 0.dp

fun Animatable(initialValue: Dp) = Animatable(
    initialValue,
    DpToVector,
)

private val DpToVector: TwoWayConverter<Dp, AnimationVector1D> =
    TwoWayConverter({ AnimationVector1D(it.value) }, { it.value.dp })

@Composable
private fun animateBoxHorizontal(dbAnimateAsState: Dp) {
    Box(
        modifier = Modifier
            .height(32.dp)
            .width(300.dp)
            .background(Color.Yellow)
    ) {
        Box(
            modifier = Modifier
                .offset(dbAnimateAsState, 0.dp)
                .size(32.dp)
                .background(Color.Red)
        )
    }
    Spacer(modifier = Modifier.height(16.dp))
}

@Composable
fun Animation11() {
    Column(
        modifier = Modifier.fillMaxSize(),
        verticalArrangement = Arrangement.Center,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        var currentPage by remember { mutableStateOf(0) }
        Crossfade(
            targetState = currentPage,
            animationSpec = tween(durationMillis = 1000)
        ) { screen -> ColorBox(screen)
        }
        Button(onClick = {
            currentPage = (0..0xFFFFFF).random()
        }) {
            Text("Click Me")
        }
    }
}

@Composable
fun ColorBox(screen: Int) {
    Box(
        Modifier
            .size(100.dp)
            .background(Color(screen + 0xFF000000)),
        contentAlignment = Alignment.Center
    ) {
        Text(get6DigitHex(screen), color = contrastColor(screen))
    }
}

enum class BoxState {
    Collapsed,
    Expanded
}

@Composable
fun Animation12() {
    var currentState by remember { mutableStateOf(BoxState.Collapsed) }
    val transition = updateTransition(targetState = currentState, label = "")

    val rect by transition.animateRect(transitionSpec = transitioningSpec(), label = "") { state ->
        when (state) {
            BoxState.Collapsed -> Rect(0f, 0f, 100f, 100f)
            BoxState.Expanded -> Rect(100f, 100f, 300f, 300f)
        }
    }

    val color by transition.animateColor(transitionSpec = transitioningSpec(), label = "") { state ->
        when (state) {
            BoxState.Collapsed -> MaterialTheme.colors.primary
            BoxState.Expanded -> MaterialTheme.colors.secondary
        }
    }

    val borderWidth by transition.animateDp(transitionSpec = transitioningSpec(), label = "") { state ->
        when (state) {
            BoxState.Collapsed -> 5.dp
            BoxState.Expanded -> 20.dp
        }
    }

    Column {
        Canvas(modifier = Modifier.fillMaxWidth()
            .height(500.dp)
            .border(BorderStroke(borderWidth, Color.Green))) {
            drawPath(Path().apply { addRect(rect) }, color)
        }
        Button(onClick = {
            currentState = if(currentState == BoxState.Expanded)
                BoxState.Collapsed else BoxState.Expanded
        }) {
            Text("Click Me")
        }
    }
}

@OptIn(ExperimentalTransitionApi::class)
@Composable
fun Animation13() {
    var currentState by remember { mutableStateOf(BoxState.Collapsed) }
    val transition = updateTransition(currentState, label = "")

    val rect by transition.animateRect(transitionSpec = transitioningSpec(), label = "") { state ->
        when (state) {
            BoxState.Collapsed -> Rect(0f, 0f, 100f, 100f)
            BoxState.Expanded -> Rect(100f, 100f, 300f, 300f)
        }
    }

    Column {
        Canvas(
            modifier = Modifier.fillMaxWidth().height(200.dp)
                .border(BorderStroke(1.dp, Color.Green))
        ) {
            drawPath(Path().apply { addRect(rect) }, Color.Red)
        }
        NumberPad(transition.createChildTransition { currentState })
        Button(onClick = {
            currentState =
                if (currentState == BoxState.Expanded) BoxState.Collapsed
                else BoxState.Expanded
        }) {
            Text("Click Me")
        }
    }

    LaunchedEffect(Unit) {
        currentState = BoxState.Expanded
    }
}

@Composable
fun NumberPad(transition: Transition<BoxState>) {
    val rect by transition.animateRect(transitionSpec = transitioningSpec(), label = "") { state ->
        when (state) {
            BoxState.Collapsed -> Rect(0f, 0f, 100f, 100f)
            BoxState.Expanded -> Rect(100f, 100f, 300f, 300f)
        }
    }

    Column {
        Canvas(
            modifier = Modifier.fillMaxWidth().height(200.dp)
                .border(BorderStroke(1.dp, Color.Green))
        ) {
            drawPath(Path().apply { addRect(rect) }, Color.Red)
        }
    }
}

@Composable
fun <T>transitioningSpec(): @Composable() (Transition.Segment<BoxState>.() -> FiniteAnimationSpec<T>) =
    {
        when {
            BoxState.Expanded isTransitioningTo BoxState.Collapsed ->
                spring(stiffness =20f, dampingRatio = 0.25f)
            else ->
                tween(durationMillis = 3000)
        }
    }

@OptIn(ExperimentalMaterialApi::class, ExperimentalAnimationApi::class)
@Composable
fun Animation14() {
    var selected by remember { mutableStateOf(false) }
    val transition = updateTransition(selected, label = "")
    val borderColor by transition.animateColor (label = "") { isSelected ->
        if (isSelected) Color.Magenta else Color.White
    }
    val elevation by transition.animateDp(label = "") { isSelected ->
        if (isSelected) 10.dp else 2.dp
    }

    Surface(
        onClick = { selected = !selected },
        shape = RoundedCornerShape(8.dp),
        border = BorderStroke(2.dp, borderColor),
        elevation = elevation
    ) {
        Column(modifier = Modifier.fillMaxWidth().padding(16.dp)) {
            Text(text = "Hello, world!")
            // AnimatedVisibility as a part of the transition.
            transition.AnimatedVisibility(
                visible = { targetSelected -> targetSelected },
                enter = expandVertically(),
                exit = shrinkVertically()
            ) {
                Text(text = "It is fine today.")
            }
            // AnimatedContent as a part of the transition.
            transition.AnimatedContent { targetState ->
                if (targetState) {
                    Text(text = "Selected")
                } else {
                    Icon(imageVector = Icons.Default.Phone, contentDescription = "Phone")
                }
            }
        }
    }
}