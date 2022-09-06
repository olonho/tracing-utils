// Copyright 2000-2021 JetBrains s.r.o. and contributors. Use of this source code is governed by the Apache 2.0 license that can be found in the LICENSE file.
import androidx.compose.animation.core.*
import androidx.compose.material.MaterialTheme
import androidx.compose.desktop.ui.tooling.preview.Preview
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.Button
import androidx.compose.material.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.scale
import androidx.compose.ui.window.Window
import androidx.compose.ui.window.application

@Composable
@Preview
fun App() {
    MaterialTheme {
        val infiniteTransition = rememberInfiniteTransition()
        val f by infiniteTransition.animateFloat(
            initialValue = 1f,
            targetValue = 2.5f,
            animationSpec = infiniteRepeatable(
                animation = tween(8000, easing = LinearEasing),
                repeatMode = RepeatMode.Reverse
            )
        )
        Column(
            modifier = Modifier.fillMaxSize(),
            verticalArrangement = Arrangement.Center,
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Button(onClick = {}, modifier = Modifier.scale(f)) {
                Text("Hello")
            }
        }
    }
}

fun main() = application {
    Window(onCloseRequest = ::exitApplication) {
        //App()
        //CrossFade()
        AllAnimations()
    }
}

@Composable
fun AllAnimations() {
    val state = rememberScrollState(0)
    Column(modifier = Modifier.verticalScroll(state)) {
        Animation1()
        Animation2()
        Animation3()
        Animation4()
        Animation5()
        Animation6()
        Animation7()
        Animation8()
        Animation9()
        Animation10()
        Animation11()
        Animation12()
        Animation13()
        Animation14()
    }
}