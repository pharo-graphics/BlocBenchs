/* Translated from src/BlocBenchs-Alexandrie/AeBenchAthensCircleGrid.class.st
 *
 * On Mac after `brew install cairo`:
 *   gcc -O3 -I/usr/local/Cellar/cairo/1.18.0/include -L/usr/local/Cellar/cairo/1.18.0/lib -lcairo -o circle_bench circle_bench.c
 *
 */

#include <cairo.h>
#include <math.h>
#include <time.h>
#include <stdio.h>

int main() {
//    const char* version = cairo_version_string();
//    printf("Cairo version: %s\n", version);

    // Initialize the Cairo surface and context
    int width = 900;
    int height = 450;
    int gridWidth = 20;
    int gridHeight = 10;
    double cellWidth = (double) width / gridWidth;
    double cellHeight = (double) height / gridHeight;
    double radius = fmin(cellWidth, cellHeight) / 2;

    cairo_surface_t* surface = cairo_image_surface_create(CAIRO_FORMAT_ARGB32, width, height);
    cairo_t* cr = cairo_create(surface);
    cairo_set_antialias(cr, CAIRO_ANTIALIAS_GOOD);   
    cairo_set_line_width(cr, 1.0);

    for (int i = 0; i < 35; i++) {

        // Clear surface
        cairo_save(cr);
        cairo_set_operator(cr, CAIRO_OPERATOR_CLEAR);
        cairo_paint(cr);
        cairo_restore(cr);

        clock_t start = clock();

        // Draw the grid of circles
        for (int row = 0; row < gridHeight; row++) {
            for (int col = 0; col < gridWidth; col++) {
                cairo_save(cr);

                cairo_translate(cr, col * cellWidth, row * cellHeight);
                cairo_arc(cr, radius, radius, radius, 0.0, 2 * M_PI);

                // Set the fill color to yellow
                cairo_set_source_rgb(cr, 1.0, 1.0, 0.0);
                cairo_fill_preserve(cr);

                // Set the stroke color to red
                cairo_set_source_rgb(cr, 1.0, 0.0, 0.0);
                cairo_stroke(cr);

                cairo_restore(cr);
            }
        }

        // Calculate and print the execution time
        clock_t end = clock();
        double duration = (double)(end - start) / CLOCKS_PER_SEC;
        double duration_ms = duration * 1000;
        printf("%.2f ", duration_ms);
    }

    // Clean up and save the image
    cairo_destroy(cr);
    cairo_surface_flush(surface);
    cairo_surface_write_to_png(surface, "circle_bench.png");
    cairo_surface_destroy(surface);

    return 0;
}