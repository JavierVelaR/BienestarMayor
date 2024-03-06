package com.example.bienestarmayor
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import androidx.fragment.app.Fragment

import com.bumptech.glide.Glide

class PerfilFragment : Fragment() {

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        val view = inflater.inflate(R.layout.fragment_perfil, container, false)

        // Accede a la ImageView en el diseño
        val profileImage = view.findViewById<ImageView>(R.id.imagenPerfil)

        // Carga la foto desde el almacenamiento y configúrala en la ImageView
        val imagePath = obtenerRutaDeLaFoto() // Reemplaza con tu lógica para obtener la ruta
        cargarFoto(imagePath, profileImage)

        // Otros elementos del fragmento según tus necesidades

        return view
    }

    // Método para cargar la foto en la ImageView
    private fun cargarFoto(imagePath: String?, imageView: ImageView) {
        if (!imagePath.isNullOrEmpty()) {
            // Utiliza una biblioteca como Glide o Picasso para cargar imágenes
            Glide.with(this)
                .load(imagePath)
                .into(imageView)
        }
    }

    // Método para obtener la ruta de la foto desde el almacenamiento
    private fun obtenerRutaDeLaFoto(): String? {
        // Implementa la lógica para obtener la ruta de la foto desde el almacenamiento
        // Puedes usar SharedPreferences, Base de Datos, etc.
        // Devuelve la ruta de la foto o null si no hay ninguna foto guardada
        return null/* Lógica para obtener la ruta de la foto */
    }
}
