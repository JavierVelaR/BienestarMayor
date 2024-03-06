package com.example.bienestarmayor

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import android.view.View
import androidx.appcompat.widget.Toolbar
import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentManager
import androidx.fragment.app.FragmentTransaction

class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)


        // Configuración de la barra de herramientas
        val toolbar: Toolbar = findViewById(R.id.toolbar)
        setSupportActionBar(toolbar)
    }

    // Función llamada al hacer clic en el icono del menú
    fun onMenuButtonClick(view: View) {
        // Implementa el código para desplegar el menú lateral aquí
        Log.d("Boton menu", "Se ha pulsado el menu.")

        // Crea y muestra el fragmento de menú
        val fragmentManager: FragmentManager = supportFragmentManager
        val fragmentTransaction: FragmentTransaction = fragmentManager.beginTransaction()

        val menuFragment = MenuFragment()
        fragmentTransaction.replace(R.id.container, menuFragment)
        fragmentTransaction.addToBackStack(null)
        fragmentTransaction.commit()
    }

    // Función llamada al hacer clic en el icono del perfil
    fun onProfileButtonClick(view: View) {
        // Implementa el código para navegar a la pantalla de ajustes/perfil aquí
        Log.d("Boton perfil", "Se ha pulsado el perfil.")

        // Crea y muestra el fragmento de perfil
        val fragmentManager: FragmentManager = supportFragmentManager
        val fragmentTransaction: FragmentTransaction = fragmentManager.beginTransaction()

        val perfilFragment = PerfilFragment()
        fragmentTransaction.replace(R.id.container, perfilFragment)
        fragmentTransaction.addToBackStack(null)
        fragmentTransaction.commit()
    }
}