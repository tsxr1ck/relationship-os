"use client";

import React, { useRef, useState } from "react";
import { Share, Check, Heart } from "lucide-react";
import { toBlob } from "html-to-image";

interface ShareActionProps {
    scorePct: number;
    matchCount: number;
    totalRounds: number;
    headline: string;
    body: string;
    playerNames: string;
}

export function ShareAction({
    scorePct,
    matchCount,
    totalRounds,
    headline,
    body,
    playerNames,
}: ShareActionProps) {
    const posterRef = useRef<HTMLDivElement>(null);
    const [isExporting, setIsExporting] = useState(false);
    const [justExported, setJustExported] = useState(false);

    const handleShare = async () => {
        if (!posterRef.current || isExporting) return;
        setIsExporting(true);

        try {
            // Small artificial delay to ensure fonts/CSS are absolutely settled layout-wise
            await new Promise((resolve) => setTimeout(resolve, 100));

            const blob = await toBlob(posterRef.current, {
                quality: 0.95,
                cacheBust: true,
                style: {
                    background: "#151311", // Hardcoded '--color-base' for safety on canvas
                },
            });

            if (!blob) throw new Error("Could not generate image blob");

            const file = new File([blob], "sintonia-resultado.png", {
                type: "image/png",
            });

            if (navigator.canShare && navigator.canShare({ files: [file] })) {
                await navigator.share({
                    title: "Nuestro nivel de Sintonía",
                    text: "Mira nuestro resultado en Sintonia 🖤",
                    files: [file],
                });
            } else {
                // Fallback to auto-download if Web Share API is missing (e.g. desktop)
                const url = URL.createObjectURL(blob);
                const a = document.createElement("a");
                a.href = url;
                a.download = "sintonia-resultado.png";
                a.click();
                URL.revokeObjectURL(url);
            }

            setJustExported(true);
            setTimeout(() => setJustExported(false), 3000);
        } catch (error) {
            console.error("Error sharing or saving image:", error);
            alert("No se pudo generar la imagen. Intenta desde el móvil.");
        } finally {
            setIsExporting(false);
        }
    };

    return (
        <>
            <div className="flex justify-center mt-6">
                <button
                    onClick={handleShare}
                    disabled={isExporting}
                    className={`inline-flex items-center gap-2 rounded-full px-6 py-3 font-semibold transition-all ${
                        justExported
                            ? "bg-success text-white"
                            : "bg-ai text-base hover:bg-ai/90 shadow-[0_0_20px_rgba(216,154,91,0.2)]"
                    }`}
                >
                    {isExporting ? (
                        <div className="w-5 h-5 border-2 border-base/30 border-t-base rounded-full animate-spin" />
                    ) : justExported ? (
                        <Check className="w-5 h-5" />
                    ) : (
                        <Share className="w-5 h-5" />
                    )}
                    {isExporting
                        ? "Generando..."
                        : justExported
                        ? "¡Listo!"
                        : "Compartir Resultado"}
                </button>
            </div>

            {/* 
              HIDDEN POSTER RENDER DOM 
              We render it absolute and highly off-screen so the user never sees it, 
              but it remains perfectly structured for html-to-image to snapshot it.
            */}
            <div className="overflow-hidden pointer-events-none absolute -left-[9999px] top-0">
                <div
                    ref={posterRef}
                    // Exact IG Story ratio scaled down for crispy rendering
                    className="relative flex flex-col items-center justify-between overflow-hidden bg-[#151311] p-10 text-center text-[#f4ede6]"
                    style={{
                        width: "1080px",
                        height: "1920px",
                        fontFamily: "Inter, sans-serif",
                    }}
                >
                    {/* Background glows */}
                    <div className="absolute inset-0 z-0">
                        <div className="absolute top-0 right-0 h-[600px] w-[600px] translate-x-1/3 -translate-y-1/3 rounded-full bg-[#d89a5b] opacity-20 blur-[150px]" />
                        <div className="absolute bottom-0 left-0 h-[800px] w-[800px] -translate-x-1/3 translate-y-1/3 rounded-full bg-[#e8748a] opacity-[0.15] blur-[150px]" />
                        <div className="absolute top-1/2 left-1/2 h-[500px] w-[500px] -translate-x-1/2 -translate-y-1/2 rounded-full bg-[#151311]" />
                    </div>

                    <div className="relative z-10 w-full pt-16">
                        <div className="mx-auto mb-16 inline-flex items-center gap-3 rounded-full border border-[rgba(216,154,91,0.3)] bg-[rgba(37,28,18,0.8)] px-6 py-2 text-2xl font-bold uppercase tracking-[0.2em] text-[#d89a5b]">
                            SINTONÍA
                        </div>

                        {/* Huge Score Circle */}
                        <div className="relative mx-auto flex h-[400px] w-[400px] shrink-0 items-center justify-center">
                            <div
                                className="absolute inset-0 rounded-full"
                                style={{
                                    background: `conic-gradient(#E8748A ${
                                        scorePct * 3.6
                                    }deg, #2d2622 0deg)`,
                                }}
                            />
                            <div className="flex h-[360px] w-[360px] items-center justify-center rounded-full bg-[#151311] border-4 border-[#26211e] shadow-inner">
                                <span
                                    className="text-[120px] font-bold"
                                    style={{ fontFamily: "'Playfair Display', serif" }}
                                >
                                    {scorePct}%
                                </span>
                            </div>
                        </div>

                        <div className="mt-12 text-3xl font-medium tracking-wide text-[#c7b9ab]">
                            {playerNames}
                        </div>
                        <div className="mt-4 text-4xl font-bold text-[#f4ede6]">
                            {matchCount} de {totalRounds} coincidencias
                        </div>
                    </div>

                    {/* AI Centerpiece */}
                    <div className="relative z-10 my-auto w-full max-w-[850px] rounded-[64px] border border-[rgba(216,154,91,0.2)] bg-[rgba(37,28,18,0.6)] p-16 shadow-[0_0_80px_rgba(216,154,91,0.1)] backdrop-blur-xl">
                        <h1
                            className="mb-8 text-7xl font-bold leading-tight text-[#d89a5b]"
                            style={{ fontFamily: "'Playfair Display', serif" }}
                        >
                            {headline}
                        </h1>
                        <p className="text-4xl leading-relaxed font-light text-[#c7b9ab]">
                            {body}
                        </p>
                    </div>

                    {/* Minimalist Footer */}
                    <div className="relative z-10 w-full border-t border-[rgba(52,46,40,0.8)] pb-8 pt-10">
                        <div className="flex items-center justify-center gap-4 text-2xl font-semibold tracking-widest text-[#9a8d82] uppercase">
                            <Heart className="w-8 h-8 fill-current opacity-70" />
                            Relationship OS
                        </div>
                        <p className="mt-6 text-xl tracking-[0.2em] text-[rgba(154,141,130,0.6)] uppercase">
                            app.relationshipos.com
                        </p>
                    </div>
                </div>
            </div>
        </>
    );
}
